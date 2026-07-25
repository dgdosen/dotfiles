#!/usr/bin/env zsh
#
# Containerized variant of project_b_tmracingdata_scrape.sh.
#
#   tmracingdata -> project_b_tmracingdata_scrape_cli:bun
#
# The last job in the fleet to be containerized. The native script it replaces
# ran `pnpm build && pnpm dev fetch-all && pnpm dev process` under `set -e` with
# no lock, i.e. exactly the host-toolchain-drift shape the images exist to
# remove. Its launch agent was also never symlinked into ~/Library/LaunchAgents,
# so the 19:15 nightly had never fired on this machine — automated commits in
# project_b_tmracingdata stop on 2026-07-19 and everything after that sat
# uncommitted until it was swept up by hand on 2026-07-25.
#
# TWO durable outputs, both mounts (see readme.container.md in the CLI repo):
#   /ingest    <- the Dropbox share's dropoff_tm_racing_data
#                 fetch-all writes PDFs to to_be_processed/ and horse_details/;
#                 process reads them and archives to processed/
#   /data_repo <- project_b_tmracingdata, the JSON output git tree
#                 process writes data/<TRACK>/*.json, commits one card per
#                 commit, and PUSHES
#
# Unlike the rest of the fleet this image also carries poppler-utils: `process`
# shells out to `pdftotext -layout`, whose column spacing the RsPos parser
# anchors on.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman, assert_prod_env, podman_run_bounded, env_val, SHARE_HOST

acquire_lock "$HOME/.cron_support/project_b_tmracingdata_scrape.container.lock"

# ---------------------------------------------------------------- config ----

TMRD_IMAGE="${TMRD_IMAGE:-localhost/project_b_tmracingdata_scrape_cli:bun}"
TMRD_CLI_REPO="$HOME/dev/project_b_tmracingdata_scrape_cli"

# PRODUCTION ONLY, deliberately not overridable. This CLI's `process` posts to
# EVERY configured API target, so a nightly must not carry a dev target it might
# silently half-post to (or stall on when local Rails is down). The prod env-file
# omits DEV_API_ROOT entirely rather than blanking it — buildApiClientsForTarget()
# gates on the variable being set. This repo names the root PROD_API_ROOT.
TMRD_ENV_FILE="$TMRD_CLI_REPO/.env.container.prod"

# Host-side view of the two mounts. project_b_share is a symlink into the Dropbox
# CloudStorage tree; SHARE_HOST resolves to the same directory the CLI's .env
# spells out in full, so use the fleet's variable rather than a second literal.
TMRD_INGEST_HOST="$SHARE_HOST/documents/dropoff_tm_racing_data"
TMRD_DATA_REPO="$HOME/dev/project_b_tmracingdata"
SSH_KEY="$HOME/.ssh/id_ed25519"

# Bound each container run (see podman_run_bounded in _lib.sh). PER INVOCATION,
# and this script makes two. No containerized history to size from, so this is
# deliberately loose: `fetch -t DMR` alone pulled 4 cards and 365 horse-detail
# PDFs, and fetch-all does that for every GPS track. Revisit once the log has a
# week of real runs in it — but err long, since truncating a fetch loses a day.
CONTAINER_TIMEOUT="${CONTAINER_TIMEOUT:-7200}"

# ------------------------------------------------------------- functions ----

# Both durable paths must resolve inside a mount, or the container writes into
# its own filesystem and --rm discards the work while the run still reports
# success. Same guard the drf/drf_debut download paths get, doubled.
assert_container_paths_are_mounted() {
    local ingest repo
    ingest=$(env_val INGEST_DIRECTORY "$TMRD_ENV_FILE")
    repo=$(env_val DATA_REPO_FOLDER "$TMRD_ENV_FILE")

    if [[ "$ingest" != /ingest* ]]; then
        echo "[TMRD] ✗ REFUSING TO RUN: INGEST_DIRECTORY is '$ingest'."
        echo "[TMRD]   It must be under /ingest or the downloaded PDFs are silently discarded."
        return 1
    fi
    if [[ "$repo" != /data_repo* ]]; then
        echo "[TMRD] ✗ REFUSING TO RUN: DATA_REPO_FOLDER is '$repo'."
        echo "[TMRD]   It must be under /data_repo or the parsed JSON and its commits are lost."
        return 1
    fi
    echo "[TMRD] ingest (container):    $ingest"
    echo "[TMRD] data repo (container): $repo"
    return 0
}

# fetch-all only needs the ingest mount.
tmrd_fetch() {
    podman_run_bounded \
        --env-file "$TMRD_ENV_FILE" \
        -v "$TMRD_INGEST_HOST:/ingest:rw" \
        "$TMRD_IMAGE" "$@"
}

# process needs the ingest mount, the git tree, and the key it pushes with.
tmrd_process() {
    podman_run_bounded \
        --env-file "$TMRD_ENV_FILE" \
        -v "$TMRD_INGEST_HOST:/ingest:rw" \
        -v "$TMRD_DATA_REPO:/data_repo:rw" \
        -v "$SSH_KEY:/root/.ssh/id_ed25519:ro" \
        "$TMRD_IMAGE" "$@"
}

pdf_count() {
    ls -1 "$TMRD_INGEST_HOST/to_be_processed" 2>/dev/null | grep -ci '\.pdf$'
}

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B tmracingdata Scrape (containerized)"
echo "Started: $(date)"
echo "=================================================="

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. Nothing was fetched or processed."
    exit 1
fi

if ! assert_prod_env TMRD "$TMRD_ENV_FILE" PROD_API_ROOT; then exit 1; fi
if ! assert_container_paths_are_mounted; then exit 1; fi

if [ ! -d "$TMRD_INGEST_HOST" ]; then
    echo "✗ ingest directory $TMRD_INGEST_HOST is missing — is Dropbox mounted? Skipping."
    exit 1
fi
if [ ! -d "$TMRD_DATA_REPO/.git" ]; then
    echo "✗ $TMRD_DATA_REPO is not a git repo — cannot commit parsed JSON. Skipping."
    exit 1
fi
if [ ! -f "$SSH_KEY" ]; then
    echo "✗ SSH key $SSH_KEY missing — the push would fail. Skipping."
    exit 1
fi

commits_before=$(git -C "$TMRD_DATA_REPO" rev-list --count HEAD 2>/dev/null || echo 0)
echo "[TMRD] data repo at $commits_before commit(s), PDFs queued: $(pdf_count)"

# The two halves run INDEPENDENTLY, not `fetch-all && process` as documented in
# readme.container.md. process works off whatever is already in to_be_processed,
# including PDFs left by earlier days — there is one queued right now — so
# chaining them would let a single bad fetch (site down, login change) strand
# every queued card indefinitely. Attempt both, remember each exit code, and fail
# the run at the end if either failed. Same reasoning as drf_fetch.
overall=0

# 1) fetch-all: every GPS track in the rolling 9-day window -> /ingest.
echo ""
echo "[TMRD] fetching cards (fetch-all)..."
tmrd_fetch fetch-all
rc=$?
if [ $rc -ne 0 ]; then
    echo "[TMRD] ✗ fetch-all exited $rc (continuing to process what is already queued)"
    overall=$rc
else
    echo "[TMRD] ✓ fetch completed; PDFs queued: $(pdf_count)"
fi

# 2) process: parse -> JSON -> commit per card -> push -> POST -> archive PDF.
# Pushing is deliberate: the repo has a remote and a failed push is non-fatal
# (the commit survives locally and the next run carries it).
echo ""
echo "[TMRD] parsing and committing (process)..."
tmrd_process process
rc=$?
if [ $rc -ne 0 ]; then
    echo "[TMRD] ✗ process exited $rc"
    overall=$rc
fi

commits_after=$(git -C "$TMRD_DATA_REPO" rev-list --count HEAD 2>/dev/null || echo 0)
echo ""
echo "[TMRD] PDFs still queued: $(pdf_count)"

# The CLI reports success even when it committed nothing, so check the repo. A
# day with no new cards is legitimate, hence a warning rather than a failure.
if [ "$commits_after" -gt "$commits_before" ]; then
    echo "[TMRD] ✓ $((commits_after - commits_before)) new commit(s) in $TMRD_DATA_REPO"
else
    echo "[TMRD] ! no new commits in $TMRD_DATA_REPO"
    echo "[TMRD]   Either there were no new cards, or parsing/committing failed."
fi

# A failed push leaves the commits local; surface it so they do not pile up
# silently the way the uncommitted JSON did before this job was wired up.
unpushed=$(git -C "$TMRD_DATA_REPO" rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)
if [ "${unpushed:-0}" -gt 0 ]; then
    echo "[TMRD] ! $unpushed commit(s) not pushed — the next run will carry them."
fi

echo ""
echo "=================================================="
echo "tmracingdata scrape completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_tmracingdata_scrape.container.txt

# Non-zero if either half failed (both were still attempted).
exit $overall

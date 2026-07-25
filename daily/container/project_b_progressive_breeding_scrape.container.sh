#!/usr/bin/env zsh
#
# Containerized variant of project_b_progressive_breeding_scrape.sh.
#
#   progressive -> project_b_progressive_breeding_scrape_cli:bun
#
# Like tmracingdata, this one was never symlinked into ~/Library/LaunchAgents, so
# its 06:30/18:30 nightly had never fired on this machine. The native script it
# replaces ran `pnpm build && pnpm dev fetch && pnpm dev process` under `set -e`
# with no lock — and against the host's Google Chrome, so a Chrome update could
# break it silently. The image carries bun, Chromium and poppler.
#
# THREE mounts, all durable:
#   /ingest_daily  <- dropoff_progressive_daily
#                     `fetch` downloads sire-rating PDFs into to_be_processed/,
#                     `process` archives them into processed/
#   /ingest_yearly <- dropoff_progressive_pdf
#                     the yearly dropoff, used by the `ingest` subcommand only.
#                     Not part of this nightly; mounted so a manual `ingest` run
#                     against this image works without a different invocation.
#   /data_repo     <- project_b_progressive_data
#                     `process` writes daily/*.json, then git add/commit/PUSH
#
# NOTE on failure modes: the CLI catches its own git errors and logs them as
# warnings, so a broken push degrades to "JSON written, nothing committed" while
# the command still exits 0. The post-run commit check below is what turns that
# back into something visible.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman, assert_prod_env, podman_run_bounded, env_val, SHARE_HOST

acquire_lock "$HOME/.cron_support/project_b_progressive_breeding_scrape.container.lock"

# ---------------------------------------------------------------- config ----

PROG_IMAGE="${PROG_IMAGE:-localhost/project_b_progressive_breeding_scrape_cli:bun}"
PROG_CLI_REPO="$HOME/dev/project_b_progressive_breeding_scrape_cli"

# PRODUCTION ONLY, deliberately not overridable: `process` posts to EVERY
# configured API target, so a dev target left in the env-file would make an
# unattended run depend on local Rails. The prod file omits DEV_API_ROOT.
PROG_ENV_FILE="$PROG_CLI_REPO/.env.container.prod"

# Host-side view of the mounts. project_b_share is a symlink into the Dropbox
# CloudStorage tree and resolves to the same directory the CLI's .env spells out
# in full, so use the fleet's variable rather than a second literal.
PROG_INGEST_DAILY_HOST="$SHARE_HOST/documents/dropoff_progressive_daily"
PROG_INGEST_YEARLY_HOST="$SHARE_HOST/documents/dropoff_progressive_pdf"
PROG_DATA_REPO="$HOME/dev/project_b_progressive_data"
SSH_KEY="$HOME/.ssh/id_ed25519"

# Bound each container run (see podman_run_bounded in _lib.sh). PER INVOCATION,
# and this script makes two. No containerized history to size from, so this is
# deliberately loose — `fetch` walks every watched track with a browser. Revisit
# once the log has a week of real runs; err long, since truncating a fetch costs
# a half-day (this job runs twice daily, at 06:30 and 18:30).
CONTAINER_TIMEOUT="${CONTAINER_TIMEOUT:-7200}"

# ------------------------------------------------------------- functions ----

# Every durable path must resolve inside a mount, or the container writes into
# its own filesystem and --rm discards the work while the run still reports
# success. Same guard as tmracingdata, tripled.
assert_container_paths_are_mounted() {
    local daily yearly repo
    daily=$(env_val DAILY_INGEST_DIRECTORY "$PROG_ENV_FILE")
    yearly=$(env_val INGEST_DIRECTORY "$PROG_ENV_FILE")
    repo=$(env_val DATA_REPO_FOLDER "$PROG_ENV_FILE")

    if [[ "$daily" != /ingest_daily* ]]; then
        echo "[PROG] ✗ REFUSING TO RUN: DAILY_INGEST_DIRECTORY is '$daily'."
        echo "[PROG]   It must be under /ingest_daily or the downloaded PDFs are silently discarded."
        return 1
    fi
    if [[ "$yearly" != /ingest_yearly* ]]; then
        echo "[PROG] ✗ REFUSING TO RUN: INGEST_DIRECTORY is '$yearly'."
        echo "[PROG]   It must be under /ingest_yearly (used by the ingest subcommand)."
        return 1
    fi
    if [[ "$repo" != /data_repo* ]]; then
        echo "[PROG] ✗ REFUSING TO RUN: DATA_REPO_FOLDER is '$repo'."
        echo "[PROG]   It must be under /data_repo or the parsed JSON and its commits are lost."
        return 1
    fi
    echo "[PROG] daily ingest (container):  $daily"
    echo "[PROG] yearly ingest (container): $yearly"
    echo "[PROG] data repo (container):     $repo"
    return 0
}

# Both halves get every mount: `fetch` only needs the daily dropoff, but keeping
# one invocation shape means the two commands cannot drift apart.
prog_run() {
    podman_run_bounded \
        --env-file "$PROG_ENV_FILE" \
        -v "$PROG_INGEST_DAILY_HOST:/ingest_daily:rw" \
        -v "$PROG_INGEST_YEARLY_HOST:/ingest_yearly:rw" \
        -v "$PROG_DATA_REPO:/data_repo:rw" \
        -v "$SSH_KEY:/root/.ssh/id_ed25519:ro" \
        "$PROG_IMAGE" "$@"
}

pdf_count() {
    ls -1 "$PROG_INGEST_DAILY_HOST/to_be_processed" 2>/dev/null | grep -ci '\.pdf$'
}

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B Progressive Breeding Scrape (containerized)"
echo "Started: $(date)"
echo "=================================================="

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. Nothing was fetched or processed."
    exit 1
fi

if ! assert_prod_env PROG "$PROG_ENV_FILE" PROD_API_ROOT; then exit 1; fi
if ! assert_container_paths_are_mounted; then exit 1; fi

if [ ! -d "$PROG_INGEST_DAILY_HOST" ]; then
    echo "✗ daily ingest directory $PROG_INGEST_DAILY_HOST is missing — is Dropbox mounted? Skipping."
    exit 1
fi
if [ ! -d "$PROG_DATA_REPO/.git" ]; then
    echo "✗ $PROG_DATA_REPO is not a git repo — cannot commit parsed JSON. Skipping."
    exit 1
fi
if [ ! -f "$SSH_KEY" ]; then
    echo "✗ SSH key $SSH_KEY missing — the push would fail. Skipping."
    exit 1
fi

commits_before=$(git -C "$PROG_DATA_REPO" rev-list --count HEAD 2>/dev/null || echo 0)
echo "[PROG] data repo at $commits_before commit(s), PDFs queued: $(pdf_count)"

# The two halves run INDEPENDENTLY, not `fetch && process` as the native script
# had it. process works off whatever is already in to_be_processed, including
# PDFs left by an earlier run, so chaining them would let one bad fetch (site
# down, login change) strand every queued card. Attempt both, remember each exit
# code, fail the run at the end if either failed. Same reasoning as drf_fetch.
overall=0

# 1) fetch: every watched track (the list comes from the API) -> /ingest_daily.
echo ""
echo "[PROG] fetching sire-rating PDFs (fetch)..."
prog_run fetch
rc=$?
if [ $rc -ne 0 ]; then
    echo "[PROG] ✗ fetch exited $rc (continuing to process what is already queued)"
    overall=$rc
else
    echo "[PROG] ✓ fetch completed; PDFs queued: $(pdf_count)"
fi

# 2) process: parse -> JSON into the data repo -> commit -> push -> POST -> archive.
echo ""
echo "[PROG] parsing and committing (process)..."
prog_run process
rc=$?
if [ $rc -ne 0 ]; then
    echo "[PROG] ✗ process exited $rc"
    overall=$rc
fi

commits_after=$(git -C "$PROG_DATA_REPO" rev-list --count HEAD 2>/dev/null || echo 0)
echo ""
echo "[PROG] PDFs still queued: $(pdf_count)"

# The CLI swallows its own git errors as warnings and still exits 0, so the repo
# is the only honest signal that the commit half actually worked.
if [ "$commits_after" -gt "$commits_before" ]; then
    echo "[PROG] ✓ $((commits_after - commits_before)) new commit(s) in $PROG_DATA_REPO"
else
    echo "[PROG] ! no new commits in $PROG_DATA_REPO"
    echo "[PROG]   Either there were no new ratings, or the commit/push failed —"
    echo "[PROG]   the CLI logs git failures as warnings and still exits 0."
fi

# A failed push leaves the commits local; surface it rather than let them pile up.
unpushed=$(git -C "$PROG_DATA_REPO" rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)
if [ "${unpushed:-0}" -gt 0 ]; then
    echo "[PROG] ! $unpushed commit(s) not pushed — push by hand or the next run carries them."
fi

echo ""
echo "=================================================="
echo "Progressive breeding scrape completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_progressive_breeding_scrape.container.txt

# Non-zero if either half failed (both were still attempted).
exit $overall

#!/usr/bin/env zsh
#
# Containerized variant of project_b_twinspires_scrape.sh — the ODDS fetcher.
#
#   odds -> project_b_twinspires_odds_scrape_cli:bun
#
# Division of labor: the NATIVE script posts odds to DEVELOPMENT (its .env ->
# localhost); THIS containerized variant posts to PRODUCTION via
# .env.container.prod. Both run so odds land in dev and prod. The image carries
# its own runtime (bun) and Chromium, so it is immune to host toolchain drift.
#
# Cadence: launched on a 60s StartInterval like the native job (odds move
# constantly). Runs longer than 60s just make the next fire exit 0 via the lock,
# so this self-regulates to "as often as possible, never overlapping" rather
# than truly every minute.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman, assert_prod_env, run_container

acquire_lock "$HOME/.cron_support/project_b_twinspires_scrape.container.lock"

# ---------------------------------------------------------------- config ----

TWINSPIRES_IMAGE="${TWINSPIRES_IMAGE:-localhost/project_b_twinspires_odds_scrape_cli:bun}"
TWINSPIRES_REPO="$HOME/dev/project_b_twinspires_odds_scrape_cli"

# PRODUCTION ONLY. The native script already covers dev; a nightly odds run that
# silently posted to the wrong API would be invisible, hence the prod assertion.
TWINSPIRES_ENV_FILE="$TWINSPIRES_REPO/.env.container.prod"

# ------------------------------------------------------------------ main ----

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. No odds fetched."
    exit 1
fi

if ! assert_prod_env TWINSPIRES "$TWINSPIRES_ENV_FILE"; then exit 1; fi

# Entrypoint is `bun src/index.ts`; `fetch-all` is the subcommand the native
# script runs. This scraper POSTs to the API (like gmax/egps) — it does not
# download files, so no download-path guard is needed.
run_container "$TWINSPIRES_IMAGE" "$TWINSPIRES_ENV_FILE" fetch-all
rc=$?

if [ $rc -ne 0 ]; then
    echo "[TWINSPIRES] ✗ container exited $rc"
    exit $rc
fi

touch ~/.cron_support/cron_project_b_twinspires_scrape.container.txt

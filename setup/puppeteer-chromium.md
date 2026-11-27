# Puppeteer & Chromium

How browsers for Puppeteer projects are handled across machines, and the
to-dos for migrating machines off the old shared-Chromium setup.

## Policy (as of 2026-11-27)

- **Don't install Chromium yourself.** No Homebrew `chromium` cask. Those are
  unofficial snapshot builds, unsigned, need `--no-quarantine`, don't
  auto-update, and Homebrew is phasing out casks that fail Gatekeeper.
- **Let Puppeteer manage its own browser.** It downloads Google's official,
  signed **Chrome for Testing** into the shared per-user cache
  `~/.cache/puppeteer`, one copy (~340 MB) per browser version. Projects on
  the same Puppeteer version share it.
- **No global Puppeteer env vars in dotfiles.** `.zsh/.zshrc-Darwin-arm64`
  used to set:
  ```zsh
  export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
  export PUPPETEER_EXECUTABLE_PATH=`which chromium`
  ```
  Removed: on any machine without Homebrew Chromium, `which chromium` returns
  the text "chromium not found", and that becomes the browser path, which
  breaks every Puppeteer project.
- **Same Puppeteer version everywhere, pinned exactly** (target: `24.43.1`, no
  `^`). Then each machine needs only one browser download, and fixes carry over
  between scrapers. Upgrade all repos together periodically.

## Installing a Puppeteer project (any machine)

```zsh
npm install
npm approve-scripts puppeteer          # newer npm blocks install scripts until approved
npx puppeteer browsers install chrome  # if the browser still didn't download
```

Useful:

```zsh
npx puppeteer browsers list    # what's in ~/.cache/puppeteer
npx puppeteer browsers clear   # wipe the cache; each repo re-downloads on next install
du -sh ~/.cache/puppeteer
```

## To-do: migrating a machine that used Homebrew Chromium

Do these in one sitting so scrapers aren't broken in between.

- [ ] Sync dotfiles (pulls in the removal of the two `PUPPETEER_*` exports).
- [ ] Open a **new** terminal and confirm the vars are gone:
      `env | grep PUPPETEER` (should print nothing).
- [ ] Download a matching browser for every Puppeteer repo:
      ```zsh
      for d in ~/dev/*/; do
        if grep -q '"puppeteer"' "$d/package.json" 2>/dev/null; then
          echo "== $d"
          (cd "$d" && npx puppeteer browsers install chrome)
        fi
      done
      ```
      If an old repo doesn't support that CLI, use `npm rebuild puppeteer` in it.
- [ ] Find hard-coded browser paths in repos and remove them:
      `grep -rn --include='*.js' --include='*.ts' --include='*.json' --include='.env' -e executablePath -e chromium --exclude-dir=node_modules ~/dev 2>/dev/null`
- [ ] Run each scraper once to confirm it launches.
- [ ] Check launchd/cron jobs: they may have their own env with the old vars.
- [ ] Once everything works: `brew uninstall --cask chromium`.

## To-do: converge on one Puppeteer version

Inventory (2026-11-27, `~/dev` on dg-mba-m5; versions are `package.json` ranges):

| Version | Repos |
|---|---|
| ^21.x | brisnet_scrape, drf_debut_scrape, drf_scrape, equibase_scrape, gmax_scrape, twinspires_data_scrape, twinspires_odds_scrape |
| ^24.0 | equibase_program_scrape, equibase_results_scrape, harrington_scrape |
| ^24.8 | trackmaster_fetch |
| ^24.40 | pdf_parsing, progressive_breeding_scrape, tmracing_scrape |
| ^24.43 | qf_echo |

(`project_b_*_cli` prefixes omitted.)

- [ ] **24.x repos:** set `"puppeteer": "24.43.1"`, `npm install`, smoke test.
- [ ] **21.x repos:** same bump, plus fix the breaking changes from Puppeteer 22:
  - `page.waitForTimeout(ms)` → `await new Promise(r => setTimeout(r, ms))`
  - `page.$x(xp)` → `page.$$('::-p-xpath(' + xp + ')')`
  - `page.waitForXPath(xp)` → `page.waitForSelector('::-p-xpath(' + xp + ')')`
  - `headless: true` is now Chrome's new headless mode; watch for sites that
    behave differently under automation.
  - Find candidates: `grep -rn -e waitForTimeout -e '\$x(' -e waitForXPath src`
- [ ] Pin exact versions (no `^`) in every repo.
- [ ] Afterwards, `npx puppeteer browsers clear` and re-install, leaving one browser.

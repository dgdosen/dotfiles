# project_b status reporting — plan

Where `project_b_container_status.sh` is now, and where it's headed.
Written 2026-07-30, after the Claude investigation step went live.

## Today

The script does three things in one pass, twice daily (07:03 / 21:07):

1. Reads `launchctl list` + log tails, builds a markdown report as a shell
   string.
2. Appends it to a Bear note, `project_b_status_YYYY_MM_DD`.
3. If any agent exited non-zero, pipes the report into headless
   `claude -p` and appends the triage as `## Investigation`.

The report exists only as prose, only in Bear. Nothing is queryable, and
there is no history to diff — each day is an island.

## The shift: data first, renderers second

Stop building a markdown string. Build a **JSON record**, then render it.
Bear becomes one renderer among several rather than the destination.

```
gather → run.json → ├─ bear renderer   (markdown, as today)
                    ├─ html renderer   (static page)
                    └─ future: trends, alerting, whatever
```

The value is that the JSON is the artifact that accumulates. A week of
records answers "is progressive_breeding failing more often?" without
re-reading a week of prose.

### Proposed record

One file per run, `~/log/project_b_status/YYYY-MM-DD-HHMM.json`:

```json
{
  "run_at": "2026-07-30T09:42:28-05:00",
  "host": "manistee",
  "podman_state": "running",
  "summary": { "healthy": 12, "failed": 3, "running": 1 },
  "agents": [
    {
      "name": "twinspires_data_scrape.container",
      "status": "failed",
      "exit": 137,
      "run_times": ["09:11"],
      "output_count": 0,
      "stderr_tail": "...",
      "stdout_tail": "..."
    }
  ],
  "investigation": {
    "ran": true,
    "exit": 0,
    "duration_s": 214,
    "markdown": "### twinspires_data_scrape.container\n..."
  }
}
```

Notes on the shape:

- `status` is an explicit enum (`healthy` / `failed` / `running` /
  `never_ran`) rather than something a renderer re-derives from `exit`.
  `never_ran` is worth distinguishing — see the podman note below.
- Keep the log tails *in* the record. They're what makes an old record
  useful when you come back to it; the log file itself will have rotated.
- `investigation.markdown` stays markdown, not HTML. Renderers convert.
- Emit it with `jq -n` rather than hand-rolled string interpolation —
  log tails contain quotes, backslashes and control characters that will
  produce invalid JSON otherwise. This is the one place to be strict.

### Generic web template

A single self-contained HTML file that reads the JSON. One wrinkle worth
knowing before building it: **`fetch()` of a local file fails under
`file://`** (CORS treats it as cross-origin). So either

- serve the directory (any static host — this is the "push to a static
  site" option), or
- inline the JSON into the page at write time (`<script
  type="application/json">…</script>`), giving a single portable file you
  can open by double-clicking and mail to yourself.

The inline variant is the better default for a personal dashboard: no
server, no build step, works offline, one file per day or one rolling
file for the last N days.

For the trend view, an `index.json` listing available runs lets one page
load many records without directory listing.

## Publishing: repo + static site

The history repo is what makes the trend view possible. Two mechanical
things to get right when setting it up, and one judgement call.

### Commit cadence

Two runs a day committing individually is ~700 commits a year, which
makes the log useless for reading. The records are append-only, so batch:
let the pm run commit the day's records once, or sweep weekly alongside
the existing `logrotate` job.

### Push auth from launchd

A Launch Agent has **no ssh-agent**, so `git push` over SSH fails there
even though the identical command works in an interactive shell. Either:

- give the job a deploy key with an explicit `IdentityFile`, via
  `GIT_SSH_COMMAND` in the plist environment, or
- have the job only `git commit`, and let the existing nightly dotfiles
  sweep do the pushing. Simpler, and one less credential on disk.

### Static generation — probably no build step

Once the JSON is served over HTTPS (GitHub Pages or any static host), the
`file://` CORS problem above disappears: a static `index.html` can
`fetch('data/index.json')` same-origin. **Push a new record and the site
shows it on next load — no regeneration, no workflow.**

Reach for GitHub Actions only for something the browser can't do well:

- prerendering to HTML so the page works without JS, or
- computing trends across all records at build time, rather than shipping
  a year of JSON to the client.

Both are real, neither is day-one. The shape when it's time:
`on: push: paths: ['data/**']` plus `actions/deploy-pages`.

### Public or private — decide before the first push

The records embed stderr tails: URLs, endpoints, hostnames, and
occasionally a token inside a stack trace. On a public repo that is all
permanently indexed.

Note the Free-plan trap: **Pages from a private repo requires a paid
plan.** On Free, enabling Pages publishes the site even when the repo
itself is private.

| Option | Result |
|--------|--------|
| Private repo, paid plan | Pages behind auth. Cleanest. |
| Private repo, no Pages | History syncs; render locally from the same JSON. Free, and fine for a dashboard only I read. |
| Public repo | Requires scrubbing tails to a whitelist of known-safe patterns — more work than it sounds, and it fails open. |

Leaning: private repo, render locally, until there's an actual reason to
want it on a phone. The log tails are what make an old record worth
keeping, so scrubbing them defeats the purpose.

## Open questions

- **Where does the history live?** `~/log/` is simplest but machine-local
  and not backed up. A repo gives history and sync (see above for cadence
  and auth). `~/project_b_share` (the Dropbox anchor) is a third option
  and is already the canonical cross-machine path.
- **Retention.** Records with log tails are a few KB; a year is fine.
  Decide anyway rather than discovering it.
- **Does Bear stay?** If the HTML view gets good, the Bear note may become
  redundant — or stay as the thing that actually gets read on a phone.

## Known noise to fix first

These make the daily investigation less useful until addressed. Both were
surfaced by the agent's own triage on 2026-07-30:

- `project_b_podman.container` exits **125** whenever the machine is
  already running. It is a benign no-op, but it trips the failure guard
  every single day, so Claude gets invoked to re-explain the same
  non-problem. Fix the wrapper to treat "already running" as success
  (`podman machine inspect` first).
- `project_b_podman.container.log` has **no timestamps**, which the agent
  explicitly called out as blocking its analysis — it could not map log
  entries to dates.

## Sequencing

1. Watch the current setup for a few days; tune the prompt from real output.
2. Fix the podman 125 false positive and the missing timestamps.
3. Emit `run.json` alongside the existing Bear write — additive, nothing
   breaks, and history starts accumulating immediately.
4. Stand up the history repo (private) and wire the batched commit.
5. Build the HTML renderer against a few days of real records.
6. Decide whether Bear, HTML, or both survive.

Step 3 is the one worth doing early even if the rest slips: it costs
little and it is the step that makes step 4 possible without a wait.

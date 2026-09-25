#!/usr/bin/env zsh
# Morning Claude kickoff.
#
# Purpose: fire a non-interactive `claude -p` call at 5am so the 5-hour usage
# window opens before the workday. As a side effect, produce a short daily
# briefing rooted in the quantified_worktree_census output (and whatever else
# the prompt asks for) so there's something useful waiting at breakfast.
#
# Runs headless from launchd; explicit PATH so /opt/homebrew tools resolve.

set -u
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Per-machine opt-in. FAIL CLOSED: unset/empty/anything-but-"on" means skip.
# Only one machine should burn the 5-hour Claude window at 05:00; setting the
# switch on multiple machines wastes windows for no benefit. See
# .machine.env.template for the switch definition.
[[ -f "$HOME/.machine.env" ]] && source "$HOME/.machine.env"
if [[ "${PROJECT_QF_CLAUDE_MORNING_KICKOFF:-}" != "on" ]]; then
  echo "[claude_morning] PROJECT_QF_CLAUDE_MORNING_KICKOFF is not 'on' in ~/.machine.env — skipping."
  exit 0
fi

LOG_DIR="$HOME/log"
BRIEFING="$LOG_DIR/claude_morning_briefing.md"
mkdir -p "$LOG_DIR"

# Use the quantified_worktree_census repo as the working dir: Claude has
# already been trusted there, and the briefing is rooted in its output.
cd "$HOME/dev/quantified_worktree_census"

TODAY=$(date +%Y-%m-%d)

PROMPT="Good morning. Today is ${TODAY}. Produce a concise daily briefing and write it to ${BRIEFING} (overwrite).

Sections, each a short bulleted list — skip a section if there is nothing worth saying:

1. Worktree census — run \`~/dev/quantified_worktree_census/bin/viewer\` (or read its most recent output under ~/dev/quantified_worktree_census/local/ if the viewer prints to stdout). Surface anything that stands out: dirty worktrees, branches ahead/behind, stale worktrees, uncommitted work older than a few days.
2. Dotfiles — \`git -C ~/.dotfiles status --short\` and any unpushed commits.
3. Anything else that looks like it needs attention today, drawn only from the sources above.

Keep it under ~40 lines. No preamble, no sign-off. Do not open long-running processes or edit anything outside ${BRIEFING}."

exec claude \
  --dangerously-skip-permissions \
  -p "$PROMPT"

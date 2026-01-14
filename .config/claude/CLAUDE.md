# Global Claude Code Instructions

## Preferences

- Prefer concise, direct responses
- Use existing patterns and conventions when editing codebases
- Avoid over-engineering - make minimal changes to accomplish the task

## Environment

- Primary development machine: macOS
- Shell: zsh with powerlevel10k
- Editor: Neovim (nvim)
- Terminal: Kitty/Alacritty
- Multiplexer: tmux

## Code Style

- Follow existing project conventions
- Prefer explicit over implicit
- Keep functions focused and small

## File Naming

- Use lowercase filenames (e.g., `claude.md` not `CLAUDE.md` when supported)

## Markdown Formatting

- No filler (dividers of dashes/underscores, excessive blank lines)
- Rely on markdown heading syntax for visual spacing

# TypeScript Project Guidelines

For all TypeScript projects, always use the following setup:

## Runtime and Tooling
- Use **Bun** as the runtime (not Node.js)
- Use Bun's built-in test runner
- Use Bun's built-in bundler
- Package manager: `bun install` (not npm/yarn)

## Project Initialization
When starting a new TypeScript project:
```bash
bun init
```

## Testing
- Write tests using Bun's test runner
- Run tests with: `bun test`
- Always write tests before implementation (TDD)

## Dependencies
- Install with: `bun add <package>`
- Dev dependencies: `bun add -d <package>`

## Scripts
Standard package.json scripts:
- `bun run dev` - development server
- `bun test` - run tests
- `bun run build` - build for production

## TypeScript Configuration
Use strict TypeScript settings in tsconfig.json:
```json
{
  "compilerOptions": {
    "strict": true,
    "target": "ES2022",
    "module": "ES2022"
  }
}
```

## CLI Tools with Ink
For interactive CLI tools:
- Use React + Ink for terminal UI
- Use Yoga for layout (comes with Ink)
- Example dependencies: `bun add react ink`


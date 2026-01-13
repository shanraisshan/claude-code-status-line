# Claude Code Status Line

A custom status line script for [Claude Code](https://claude.ai/claude-code) that displays context window usage, git status, and model information.

![Status Line Example](https://img.shields.io/badge/Claude%20Code-2.1.6+-blue)

![Screenshot](!/comparision.png)

## Preview

**Session start (loading state):**
```
Opus 4.5 | main (3 files uncommitted, synced 2m ago) | ░░░░░░░░░░ Loading...
```

**Normal usage:**
```
Opus 4.5 | main (3 files uncommitted, synced 2m ago) | ██░░░░░░░░ 24k/200k (12%)
```

**When context usage exceeds 80% (warning state):**
```
Opus 4.5 | main (0 files uncommitted, synced 5m ago) | ████████░░ 168k/200k (84%) ⚠
```

## Features

- **Context Window Display**: Shows actual token usage (e.g., `24k/200k`) with visual progress bar
- **Loading State**: Shows empty bar with "Loading..." at session start before context data is available
- **Git Integration**: Branch name, uncommitted file count, and sync status with remote
- **Low Context Warning**: Visual warning with ⚠ icon when context usage exceeds 80%
- **Color Themes**: Customizable accent colors (blue, orange, teal, green, lavender, rose, gold, slate, cyan, gray)
- **Last Message Preview**: Shows your last message for quick context

## Requirements

- Claude Code v2.1.6 or higher
- `jq` (JSON processor)
- `git` (for git status features)
- Bash shell

## Installation

1. **Create the scripts directory** (if it doesn't exist):
   ```bash
   mkdir -p ~/.claude/scripts
   ```

2. **Copy the script**:
   ```bash
   curl -o ~/.claude/scripts/status-line.sh https://raw.githubusercontent.com/shanraisshan/claude-code-status-line/main/status-line.sh
   ```

   Or manually copy `status-line.sh` to `~/.claude/scripts/`

3. **Make it executable**:
   ```bash
   chmod +x ~/.claude/scripts/status-line.sh
   ```

4. **Configure Claude Code** by adding to `~/.claude/settings.json`:
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "~/.claude/scripts/status-line.sh"
     }
   }
   ```

5. **Restart Claude Code** to see the new status line.

## Customization

## Claude Code 2.1.6 Update

This script utilizes the new context window fields introduced in **Claude Code v2.1.6**:

### New Fields Added in 2.1.6

| Field | Description |
|-------|-------------|
| `context_window.used_percentage` | Percentage of context window currently used |
| `context_window.remaining_percentage` | Percentage of context window remaining |

### How This Script Uses These Fields

```bash
# Read the new percentage fields directly from status line input
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty | floor')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty | floor')

# Handle three states:
# 1. Loading state - when percentage is not yet available (session start)
if [[ -z "$used_pct" || "$used_pct" == "null" ]]; then
    # Show: ░░░░░░░░░░ Loading...
fi

# 2. Warning state - when context is running low (>80% used)
if [[ $remaining_pct -le 20 ]]; then
    # Show: ████████░░ 168k/200k (84%) ⚠
fi

# 3. Normal state - show usage with progress bar
# Calculate actual token count from percentage
used_tokens=$((max_context * used_pct / 100))
# Show: ██░░░░░░░░ 24k/200k (12%)
```

## Status Line Input JSON

Claude Code pipes JSON data to your status line script via stdin. Here's the structure:

```json
{
  "context_window": {
    "context_window_size": 200000,
    "used_percentage": 24,
    "remaining_percentage": 76,
    "total_input_tokens": 505,
    "total_output_tokens": 5425,
    "current_usage": {
      "input_tokens": 9,
      "output_tokens": 227,
      "cache_creation_input_tokens": 1684,
      "cache_read_input_tokens": 24649
    }
  },
  "model": {
    "id": "claude-opus-4-5-20251101",
    "display_name": "Opus 4.5"
  },
  "cwd": "/path/to/project",
  "transcript_path": "/path/to/transcript.jsonl"
}
```
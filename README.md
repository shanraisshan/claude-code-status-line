# Claude Code Status Line

<p align="center">
  <img src="!/claude-pointing.svg" alt="Claude Code mascot jumping and pointing" width="140" height="126">
  <img src="!/claude-monitor.svg" alt="Claude Code status line monitor" width="224" height="182">
</p>

<p align="center">
  <img src="!/status-line.png" alt="Status line">
</p>

```
Model (effort) | ○○○○○○○○○○ 20k/1m Context Window (2% used) | 5hour-Limit 1% used (ends on 05:50 AM) · Weekly-Limit 2% used (ends on May 28, 04:00 PM)
```

### Comparision with usage

<p align="center">
  <img src="!/comparision.jpg" alt="Status line comparison" width="812" height="346">
</p>

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

## Other Repos

<table>
<tr>
<td align="center" width="140">
  <a href="https://github.com/shanraisshan/claude-code-best-practice"><img src="!/claude-jumping.svg" alt="Claude Code Best Practice" width="64" height="64"></a><br>
  <a href="https://github.com/shanraisshan/claude-code-best-practice"><strong>Claude Code<br>Best Practice</strong></a>
</td>
<td align="center" width="140">
  <a href="https://github.com/shanraisshan/claude-code-hooks"><img src="!/claude-speaking.svg" alt="Claude Code Hooks" width="64" height="64"></a><br>
  <a href="https://github.com/shanraisshan/claude-code-hooks"><strong>Claude Code<br>Hooks</strong></a>
</td>
<td align="center" width="140">
  <a href="https://github.com/shanraisshan/codex-cli-best-practice"><img src="!/codex-jumping.svg" alt="Codex CLI Best Practice" width="64" height="64"></a><br>
  <a href="https://github.com/shanraisshan/codex-cli-best-practice"><strong>Codex CLI<br>Best Practice</strong></a>
</td>
<td align="center" width="140">
  <a href="https://github.com/shanraisshan/codex-cli-hooks"><img src="!/codex-speaking.svg" alt="Codex CLI Hooks" width="64" height="64"></a><br>
  <a href="https://github.com/shanraisshan/codex-cli-hooks"><strong>Codex CLI<br>Hooks</strong></a>
</td>
<td align="center" width="140">
  <a href="https://github.com/shanraisshan/gemini-cli-best-practice"><img src="!/gemini-jumping.svg" alt="Gemini CLI Best Practice" width="64" height="64"></a><br>
  <a href="https://github.com/shanraisshan/gemini-cli-best-practice"><strong>Gemini CLI<br>Best Practice</strong></a>
</td>
<td align="center" width="140">
  <a href="https://github.com/shanraisshan/gemini-cli-hooks"><img src="!/gemini-speaking.svg" alt="Gemini CLI Hooks" width="64" height="64"></a><br>
  <a href="https://github.com/shanraisshan/gemini-cli-hooks"><strong>Gemini CLI<br>Hooks</strong></a>
</td>
</tr>
</table>

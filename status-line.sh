#!/bin/bash

# Simple status line - shows model and context usage only

data=$(cat)

# Get model name (strip any trailing parenthetical like "(1M context)")
model=$(echo "$data" | jq -r '.model.display_name // .model.id // "unknown"')
model=$(echo "$model" | sed 's/ *([^)]*)$//')

# Thinking / effort level, shown after the model name when available
effort_level=$(echo "$data" | jq -r '.effort.level // empty')
thinking_on=$(echo "$data" | jq -r '.thinking.enabled // empty')
if [ -n "$effort_level" ] && [ "$effort_level" != "null" ]; then
    model="${model} (${effort_level})"
elif [ "$thinking_on" = "true" ]; then
    model="${model} (thinking)"
fi

# Get context info
max_ctx=$(echo "$data" | jq -r '.context_window.context_window_size // 200000')
used_pct=$(echo "$data" | jq -r '.context_window.used_percentage // empty')

# Color codes
BLUE='\033[34m'
RED='\033[31m'
YELLOW='\033[33m'
RESET='\033[0m'

# Format context display
if [ -z "$used_pct" ] || [ "$used_pct" = "null" ]; then
    # Loading state - empty circles
    context_info="○○○○○○○○○○ loading..."
else
    pct=$(printf "%.0f" "$used_pct" 2>/dev/null || echo "$used_pct")
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100

    # Calculate tokens (used in k; max shown in m once it reaches 1000k)
    used_k=$(( max_ctx * pct / 100 / 1000 ))
    max_k=$(( max_ctx / 1000 ))
    if [ "$max_k" -ge 1000 ]; then
        max_label="$(( max_k / 1000 ))m"
    else
        max_label="${max_k}k"
    fi

    # Build circle bar (10 segments)
    bar=""
    filled=$(( pct / 10 ))

    # Blue by default, red when > 60%
    if [ "$pct" -gt 60 ]; then
        COLOR="$RED"
    else
        COLOR="$BLUE"
    fi

    for i in 0 1 2 3 4 5 6 7 8 9; do
        if [ "$i" -lt "$filled" ]; then
            bar="${bar}${COLOR}●${RESET}"
        else
            bar="${bar}○"
        fi
    done

    context_info="${bar} ${used_k}k/${max_label} (${pct}%)"
fi

# Get rate limit info (Pro/Max only; appears after the first API response)
five_hour_pct=$(echo "$data" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$data" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$data" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$data" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Format a single limit segment, coloring by severity
format_limit() {
    label="$1"
    rounded=$(printf "%.0f" "$2" 2>/dev/null || echo "$2")
    if [ "$rounded" -ge 90 ] 2>/dev/null; then
        echo "${label} ${RED}${rounded}%${RESET}"
    elif [ "$rounded" -ge 70 ] 2>/dev/null; then
        echo "${label} ${YELLOW}${rounded}%${RESET}"
    else
        echo "${label} ${rounded}%"
    fi
}

# Format an epoch with the given strftime spec (BSD/macOS date, then GNU date fallback)
format_when() {
    out=$(date -r "$1" "+$2" 2>/dev/null) || out=$(date -d "@$1" "+$2" 2>/dev/null)
    echo "$out" | tr -s ' ' | sed 's/^ //'
}

# Build "5h X% (02:39 PM) · Wk Y% (May 21, 04:00 PM)", omitting any segment that isn't present yet
limits=""
if [ -n "$five_hour_pct" ] && [ "$five_hour_pct" != "null" ]; then
    fh=$(format_limit "5h" "$five_hour_pct")
    if [ -n "$five_hour_reset" ] && [ "$five_hour_reset" != "null" ]; then
        t=$(format_when "$five_hour_reset" "%I:%M %p")
        [ -n "$t" ] && fh="${fh} (${t})"
    fi
    limits="$fh"
fi
if [ -n "$seven_day_pct" ] && [ "$seven_day_pct" != "null" ]; then
    wk=$(format_limit "Wk" "$seven_day_pct")
    if [ -n "$seven_day_reset" ] && [ "$seven_day_reset" != "null" ]; then
        when=$(format_when "$seven_day_reset" "%b %e, %I:%M %p")
        [ -n "$when" ] && wk="${wk} (${when})"
    fi
    [ -n "$limits" ] && limits="${limits} · ${wk}" || limits="$wk"
fi

# Output: Model | Context [ | Limits ]
if [ -n "$limits" ]; then
    printf '%b\n' "${model} | ${context_info} | ${limits}"
else
    printf '%b\n' "${model} | ${context_info}"
fi

#!/bin/bash
[ -z "$NVIM" ] && exit 0

input=$(cat)
event=$(echo "$input" | jq -r '.hook_event_name // empty')

case "$event" in
    UserPromptSubmit) state="busy" ;;
    Stop)         state="idle" ;;
    SessionStart) state="idle" ;;
    SessionEnd)   state="inactive" ;;
    *)            exit 0 ;;
esac

nvim --server "$NVIM" --remote-expr "v:lua.require('core.claude').set_state('$state')" >/dev/null 2>&1 &
exit 0

#!/bin/bash
[ -z "$NVIM" ] && exit 0

event=$(cat | jq -r '.hook_event_name // empty')
[ -z "$event" ] && exit 0

nvim --server "$NVIM" --remote-expr "v:lua.require('core.claude').process_event('$event')" >/dev/null 2>&1 &
exit 0

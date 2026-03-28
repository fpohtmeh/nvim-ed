$json = [Console]::In.ReadToEnd()
if (-not $json.Trim()) { exit 0 }
if (-not $env:NVIM) { exit 0 }

try { $data = $json | ConvertFrom-Json } catch { exit 0 }

$event = $data.hook_event_name
if (-not $event) { exit 0 }

nvim --server $env:NVIM --remote-expr "v:lua.require('core.claude').process_event('$event')" 2>$null
exit 0

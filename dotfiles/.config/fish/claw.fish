set -gx PATH $HOME/.npm-global/bin/ $PATH
set -gx NODE_COMPILE_CACHE /var/tmp/openclaw-compile-cache │
set -gx OPENCLAW_NO_RESPAWN 1

# OpenClaw Completion
source "/home/wsinned/.openclaw/completions/openclaw.fish"

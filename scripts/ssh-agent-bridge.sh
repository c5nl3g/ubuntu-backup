export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"

# Recreate the bridge if the socket is not being listened on
if ! ss -lx 2>/dev/null | grep -qF "$SSH_AUTH_SOCK"; then
  # Remove any stale socket file
  rm -f "$SSH_AUTH_SOCK"
  # Bridge the socket to the Windows OpenSSH agent via npiperelay
  (setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi

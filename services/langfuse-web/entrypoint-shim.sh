#!/bin/sh
# ENCRYPTION_KEY compatibility shim.
# Langfuse requires a 64-char hex (256-bit) key. Some deploy pipelines
# materialize ${{secret(32)}} (32-char) instead of ${{secret(64,hex)}}.
# If ENCRYPTION_KEY is shorter than 63 chars, stretch it to 64-hex via
# SHA-256 so both web and worker derive the SAME key from the SAME raw
# value (companion refs render identical raw strings). 64-char keys
# pass through untouched, preserving official-template behavior.
if [ -n "$ENCRYPTION_KEY" ] && [ "${#ENCRYPTION_KEY}" -lt 63 ]; then
  if command -v sha256sum >/dev/null 2>&1; then
    H=$(printf '%s' "$ENCRYPTION_KEY" | sha256sum | cut -d' ' -f1)
  else
    H=$(printf '%s' "$ENCRYPTION_KEY" | shasum -a 256 | cut -d' ' -f1)
  fi
  export ENCRYPTION_KEY="$H"
fi
exec "$@"
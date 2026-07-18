# Architecture

ShipCode for iOS uses a split data plane because its sources of truth are
different:

- GitHub issues and Projects v2 fields sync directly between iOS and GitHub.
- Sessions and automations remain owned by the desktop app and flow through a
  paired, versioned desktop bridge.

The first vertical slice is GitHub sign-in, listing one repository's issues,
moving an issue between ShipCode macro states, and seeing the desktop app adopt
that external Projects v2 change on refresh.

The desktop bridge will run in Electron's main process with an explicit command
allowlist. Pairing will exchange the desktop address, a pinned certificate
fingerprint, and a one-time code. Per-device credentials will be revocable.
Remote access is deferred to Tailscale rather than a ShipCode-hosted relay.


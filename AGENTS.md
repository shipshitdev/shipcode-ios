# ShipCode iOS

## Product boundary

- GitHub issues and Projects v2 status sync directly with GitHub.
- Desktop-only sessions and automations use the paired ShipCode desktop bridge.
- Do not introduce a hosted relay. Remote desktop access is a later Tailscale path.
- Never place GitHub credentials, pairing secrets, or generated tokens in source.

## SwiftUI conventions

- Target iOS 18 or newer.
- Use SwiftUI, Observation, structured concurrency, and value-based navigation.
- Keep client behavior behind `ShipCodeClient`; previews use deterministic demo data.
- Use stable model identity and native controls with explicit accessibility labels.

## Project generation

`project.yml` is the source of truth for the Xcode project:

```sh
xcodegen generate
```


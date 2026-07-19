# ShipCode for iOS

Native iOS control plane for [ShipCode](https://github.com/shipshitdev/shipcode).

The app uses a split data plane: GitHub-backed issues and Projects v2 status
sync directly with GitHub, while desktop-only sessions and automations connect
through an explicitly paired ShipCode desktop bridge.

The current foundation includes native Sessions, Issues, and Automations tabs;
detail views; deterministic demo data; issue movement; automation controls; and
CI. See [Architecture](docs/architecture.md) for the trust boundary.

## Development

Requirements:

- Xcode 26+
- XcodeGen 2.45+

Generate the project:

```sh
xcodegen generate
open ShipCode.xcodeproj
```

Development is tracked on the
[ShipCode iOS Roadmap](https://github.com/orgs/shipshitdev/projects/9).

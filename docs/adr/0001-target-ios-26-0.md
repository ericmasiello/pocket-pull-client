# Target iOS 26.0 as the minimum deployment target

Xcode 26.5 set the deployment target to iOS 26.5 automatically when the project was created, but iOS 26.5 is only available as a beta SDK. The `macos-26` GitHub Actions runner ships Xcode 26.2 as the default with its iOS simulator runtime pre-installed — using Xcode 26.5 requires downloading the simulator runtime on every CI run, adding several minutes of wall time.

We lowered the deployment target to iOS 26.0 so CI can use the runner's default Xcode without extra downloads. All APIs the app depends on (SwiftUI `Tab`, Liquid Glass, `TabView`) are available since iOS 26.0. If a future feature requires a higher minimum, bump the target at that time.

## Considered Options

- **Keep iOS 26.5, download simulator in CI** — Correct but adds ~3-5 min to every CI run for a runtime that provides no APIs we need.
- **Target iOS 26.0, use default Xcode 26.2** — Fast CI, no feature loss. Chosen.

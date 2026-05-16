# Pocket Pull

An iOS/SwiftUI app.

## Tech stack

- **Language**: Swift
- **UI Framework**: SwiftUI
- **Testing**: Swift Testing (`import Testing`, `@Test`, `#expect`)
- **Build**: Xcode (`Pocket Pull.xcodeproj`, scheme `Pocket Pull`)
- **Target**: iOS (Simulator: iPhone 17 Pro)

## Build & Test

```bash
# Build
xcodebuild -project "Pocket Pull.xcodeproj" -scheme "Pocket Pull" -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -quiet build 2>&1

# Test
xcodebuild test -project "Pocket Pull.xcodeproj" -scheme "Pocket Pull" -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:"Pocket PullTests" 2>&1
```

## Agent skills

### Issue tracker

Issues are tracked via GitHub Issues on `ericmasiello/pocket-pull-client`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default label vocabulary (needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout — one `CONTEXT.md` + `docs/adr/` at the repo root. See `docs/agents/domain.md`.

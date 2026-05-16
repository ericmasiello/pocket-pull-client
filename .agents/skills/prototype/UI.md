# UI Prototype

Generate **several radically different UI variations** in a single SwiftUI view, switchable via a picker or segmented control. The user flips between variants in the preview or simulator, picks one (or steals bits from each), then throws the rest away.

If the question is about logic/state rather than what something looks like — wrong branch. Use [LOGIC.md](LOGIC.md).

## When this is the right shape

- "What should this screen look like?"
- "I want to see a few options for this view before committing."
- "Try a different layout for the settings screen."
- Any time the user would otherwise spend a day picking between three vague layouts in their head.

## Two sub-shapes — strongly prefer sub-shape A

A UI prototype is much easier to judge when it's **butting up against the rest of the app** — real navigation, real data, real density. A throwaway standalone view is a vacuum: every variant looks fine in isolation. Default to sub-shape A whenever there's a plausible existing view to host the variants. Only reach for sub-shape B if the prototype genuinely has no nearby home.

### Sub-shape A — adjustment to an existing view (preferred)

The view already exists. Variants are rendered **in the same view**, gated by an `@State` enum. The existing data, environment objects, and navigation all stay — only the rendered body swaps. This is the default; pick it unless there's a specific reason not to.

If the prototype is for something that doesn't yet have a view but *would naturally live inside one* (a new section of a screen, a new card on settings, a new step in an existing flow) — that's still sub-shape A. Mount the variants inside the host view.

### Sub-shape B — a new view (last resort)

Only use this when the thing being prototyped genuinely has no existing view to live inside — e.g. an entirely new top-level screen, or a flow that can't be embedded anywhere sensible.

Create a **throwaway view file** following whatever project structure the project uses. Name it so it's obviously a prototype (e.g. include `Prototype` in the filename). Same variant-switching pattern.

Before committing to sub-shape B, sanity-check: is there really no existing view this could be embedded in? An empty screen hides design problems that a populated one would expose.

In both sub-shapes the variant switcher is identical.

## Process

### 1. State the question and pick N

Default to **3 variants**. More than 5 stops being radically different and starts being noise — cap there.

Write down the plan in a comment at the top of the prototype file:

> "Three variants of the settings screen, switchable via enum, embedded in the existing SettingsView."

### 2. Generate radically different variants

Draft each variant. Hold each one to:

- The view's purpose and the data it has access to.
- The project's design conventions (SF Symbols, system colors, existing custom components).
- A clear naming convention, e.g. `VariantA`, `VariantB`, `VariantC` as separate SwiftUI views.

Variants must be **structurally different** — different layout, different information hierarchy, different primary affordance, not just different colours. Three slightly-tweaked list views isn't a UI prototype, it's wallpaper.

### 3. Wire them together

Create a variant enum and switcher in the host view:

```swift
// Prototype — three variants of the dashboard, switchable via picker
enum DashboardVariant: String, CaseIterable {
    case a = "Compact Grid"
    case b = "Card Stack"
    case c = "Timeline"
}

struct DashboardPrototype: View {
    @State private var variant: DashboardVariant = .a

    var body: some View {
        VStack(spacing: 0) {
            // Variant content
            Group {
                switch variant {
                case .a: VariantA(data: data)
                case .b: VariantB(data: data)
                case .c: VariantC(data: data)
                }
            }
            .frame(maxHeight: .infinity)

            // Floating switcher
            PrototypeSwitcher(variant: $variant)
        }
    }
}
```

For sub-shape A (existing view): keep all the existing data and environment above the switcher; only the rendered subtree changes per variant.

For sub-shape B (new view): a standalone file named e.g. `DashboardPrototype.swift` mounts the same switcher.

### 4. Build the floating switcher

A small view pinned to the bottom of the screen:

```swift
struct PrototypeSwitcher<V: RawRepresentable & CaseIterable & Hashable>: View
where V.RawValue == String, V.AllCases: RandomAccessCollection {
    @Binding var variant: V

    var body: some View {
        Picker("Variant", selection: $variant) {
            ForEach(V.allCases, id: \.self) { v in
                Text(v.rawValue).tag(v)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .background(.ultraThinMaterial)
    }
}
```

Behaviour:

- Changing the picker updates the variant immediately.
- Visually distinct from the content (material background) so it's obviously not part of the design being evaluated.
- Hidden in production: wrap in `#if DEBUG` so it can't ship to users.

### 5. Use SwiftUI Previews

Add previews for rapid iteration — one per variant plus one with the switcher:

```swift
#Preview("All Variants") {
    DashboardPrototype()
}

#Preview("Variant A") {
    VariantA(data: .preview)
}

#Preview("Variant B") {
    VariantB(data: .preview)
}
```

### 6. Hand it over

Tell the user the prototype is ready in the preview canvas or simulator. The interesting feedback is usually **"I want the header from B with the list style from C"** — that's the actual design they want.

### 7. Capture the answer and clean up

Once a variant has won, write down which one and why (commit message, ADR, issue, or a `NOTES.md` next to the prototype if running AFK). Then:

- **Sub-shape A** — delete the losing variants and the switcher; fold the winner into the existing view.
- **Sub-shape B** — promote the winning variant to a real view, delete the prototype file and the switcher.

Don't leave variant views or the switcher lying around. They rot fast and confuse the next reader.

## Anti-patterns

- **Variants that differ only in colour or spacing.** That's a tweak, not a prototype. Real variants disagree about structure.
- **Sharing too much code between variants.** A shared header is fine; a shared layout defeats the point. Each variant should be free to throw out the layout.
- **Wiring variants to real mutations.** Read-only prototypes are fine. If a variant needs to mutate, use mock data — the question is "what should this look like", not "does the model work".
- **Promoting the prototype directly to production.** The variant code was written under prototype constraints (no tests, minimal error handling). Rewrite it properly when you fold it in.

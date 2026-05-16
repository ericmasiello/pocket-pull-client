# Logic Prototype

A tiny interactive app that lets the user drive a state model by hand. Use this when the question is about **business logic, state transitions, or data shape** — the kind of thing that looks reasonable on paper but only feels wrong once you push it through real cases.

## When this is the right shape

- "I'm not sure if this state machine handles the edge case where X then Y."
- "Does this data model actually let me represent the case where..."
- "I want to feel out what the interface should look like before writing it."
- Anything where the user wants to **press buttons and watch state change**.

If the question is "what should this look like" — wrong branch. Use [UI.md](UI.md).

## Process

### 1. State the question

Before writing code, write down what state model and what question you're prototyping. One paragraph, in a comment at the top of the file. A logic prototype that answers the wrong question is pure waste — make the question explicit so it can be checked later.

### 2. Pick the approach

Since this is a Swift/iOS project, choose the lightest-weight option that answers the question:

- **SwiftUI debug view** (preferred) — a simple view with buttons that dispatch actions and display the current state as formatted text. Runs in the preview canvas or simulator with zero setup. Best when the team is already in Xcode.
- **Swift command-line tool** — add a new command-line target to the Xcode project, or use `swift run` with a `Package.swift`. Best when the logic is pure computation with no UI dependency.
- **Swift Playground** — a `.playground` file in the project. Best for quick data-shape exploration.

Match the project's existing conventions — don't introduce new tooling just for the prototype.

### 3. Isolate the logic in a portable module

Put the actual logic — the bit that's answering the question — behind a small, pure interface that could be lifted out and dropped into the real codebase later. The UI/CLI shell around it is throwaway; the logic module shouldn't be.

The right shape depends on the question:

- **A pure reducer** — `func reduce(state: State, action: Action) -> State`. Good when actions are discrete events and state is a single value.
- **A state machine** — explicit states and transitions via an enum. Good when "which actions are even legal right now" is part of the question.
- **A small set of pure functions** over a plain data type. Good when there's no implicit current state — just transformations.
- **A class or struct with a clear method surface** when the logic genuinely owns ongoing internal state (use `@Observable` if SwiftUI needs to watch it).

Pick whichever shape best fits the question being asked. Keep it pure: no UI code, no `print()` for control flow. The shell imports it and calls into it; nothing flows the other direction.

### 4. Build the smallest shell that exposes the state

**SwiftUI debug view (preferred):**

```swift
// Prototype: Does the cart state machine handle partial refunds correctly?
struct CartPrototype: View {
    @State private var cart = CartState()

    var body: some View {
        NavigationStack {
            List {
                // Current state — always visible
                Section("State") {
                    Text(String(describing: cart))
                        .font(.system(.caption, design: .monospaced))
                }

                // Actions — buttons that dispatch into the state model
                Section("Actions") {
                    Button("Add Item") { cart = reduce(cart, .addItem(.sample)) }
                    Button("Remove Item") { cart = reduce(cart, .removeItem(0)) }
                    Button("Checkout") { cart = reduce(cart, .checkout) }
                    Button("Partial Refund") { cart = reduce(cart, .refund(amount: 5.00)) }
                    Button("Reset") { cart = CartState() }
                }
            }
            .navigationTitle("Cart Prototype")
        }
    }
}

#Preview { CartPrototype() }
```

**Command-line tool:**

Build a simple read-eval loop. Print the full state after every action. Use `readLine()` for input. The whole output should fit on one screen.

### 5. Make it runnable immediately

- **SwiftUI view**: Add a `#Preview` — the user opens the canvas and it's running. Alternatively, temporarily swap it in as the app's root view for full-device testing.
- **CLI target**: Add a scheme so the user can hit ⌘R. Document the run command.
- **Playground**: Just open and press Play.

### 6. Hand it over

Tell the user where to find it. They'll drive it themselves; the interesting moments are when they say "wait, that shouldn't be possible" or "huh, I assumed X would be different" — those are the bugs in the _idea_.

### 7. Capture the answer

When the prototype has done its job, the answer to the question is the only thing worth keeping. If the user is around, ask what it taught them. If not, leave a `NOTES.md` next to the prototype so the answer can be filled in before the prototype gets deleted.

## Anti-patterns

- **Don't add tests.** A prototype that needs tests is no longer a prototype.
- **Don't wire it to the real database or network.** Use in-memory state unless the question is specifically about persistence.
- **Don't generalise.** No "what if we wanted to support X later." The prototype answers one question.
- **Don't blur the logic and the shell together.** If the reducer / state machine references SwiftUI types or UI code, it's no longer portable. Keep the shell as a thin layer over a pure module.
- **Don't ship the shell into production.** The shell is optimised for manual exploration. The logic module behind it is the bit worth keeping.

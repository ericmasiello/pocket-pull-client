# Good and Bad Tests

## Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```swift
// GOOD: Tests observable behavior
@Test func userCanCheckoutWithValidCart() async throws {
    let cart = Cart()
    cart.add(product)
    let result = try await checkout(cart: cart, paymentMethod: paymentMethod)
    #expect(result.status == .confirmed)
}
```

Characteristics:

- Tests behavior users/callers care about
- Uses public API only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion per test

## Bad Tests

**Implementation-detail tests**: Coupled to internal structure.

```swift
// BAD: Tests implementation details via a spy
@Test func checkoutCallsPaymentServiceProcess() async throws {
    let spyPayment = SpyPaymentService()
    try await checkout(cart: cart, paymentService: spyPayment)
    #expect(spyPayment.processCallCount == 1)
    #expect(spyPayment.lastChargedAmount == cart.total)
}
```

Red flags:

- Mocking/spying internal collaborators
- Testing private methods
- Asserting on call counts/order
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT
- Verifying through external means instead of interface

```swift
// BAD: Bypasses interface to verify
@Test func createUserSavesToDatabase() async throws {
    try await createUser(name: "Alice")
    let row = try await db.query("SELECT * FROM users WHERE name = ?", ["Alice"])
    #expect(row != nil)
}

// GOOD: Verifies through interface
@Test func createUserMakesUserRetrievable() async throws {
    let user = try await createUser(name: "Alice")
    let retrieved = try await getUser(id: user.id)
    #expect(retrieved.name == "Alice")
}
```

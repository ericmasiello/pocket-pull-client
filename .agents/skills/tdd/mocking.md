# When to Mock

Mock at **system boundaries** only:

- External APIs (payment, email, etc.)
- Databases (sometimes - prefer test DB or in-memory store)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

## Designing for Mockability in Swift

At system boundaries, design protocols that are easy to substitute:

**1. Use protocol-based dependency injection**

Define a protocol for external dependencies and inject conforming types:

```swift
// Easy to mock — protocol defines the seam
protocol PaymentClient {
    func charge(amount: Decimal) async throws -> PaymentResult
}

func processPayment(order: Order, paymentClient: PaymentClient) async throws -> PaymentResult {
    try await paymentClient.charge(amount: order.total)
}

// In tests — provide a stub conforming to the protocol
struct StubPaymentClient: PaymentClient {
    var resultToReturn: PaymentResult = .success

    func charge(amount: Decimal) async throws -> PaymentResult {
        resultToReturn
    }
}
```

```swift
// Hard to mock — creates its own dependency internally
func processPayment(order: Order) async throws -> PaymentResult {
    let client = StripeClient(apiKey: Config.stripeKey)
    return try await client.charge(amount: order.total)
}
```

**2. Prefer specific protocols over generic fetchers**

Create specific methods for each external operation instead of one generic function:

```swift
// GOOD: Each method is independently stubbable
protocol UserAPI {
    func getUser(id: String) async throws -> User
    func getOrders(userId: String) async throws -> [Order]
    func createOrder(_ data: OrderData) async throws -> Order
}

// BAD: Stubbing requires conditional logic inside the stub
protocol GenericAPI {
    func fetch<T: Decodable>(endpoint: String) async throws -> T
}
```

The specific-protocol approach means:
- Each stub returns one specific shape
- No conditional logic in test setup
- Easier to see which endpoints a test exercises
- Compile-time safety per endpoint

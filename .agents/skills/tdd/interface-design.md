# Interface Design for Testability

Good interfaces make testing natural:

1. **Accept dependencies, don't create them**

   ```swift
   // Testable — dependency injected via protocol
   func processOrder(_ order: Order, gateway: PaymentGateway) async throws -> Receipt {
       try await gateway.charge(order.total)
   }

   // Hard to test — creates its own dependency
   func processOrder(_ order: Order) async throws -> Receipt {
       let gateway = StripeGateway()
       return try await gateway.charge(order.total)
   }
   ```

2. **Return results, don't produce side effects**

   ```swift
   // Testable — returns a value
   func calculateDiscount(for cart: Cart) -> Discount {
       // ...
   }

   // Hard to test — mutates in place
   func applyDiscount(to cart: inout Cart) {
       cart.total -= discount
   }
   ```

3. **Small surface area**
   - Fewer methods = fewer tests needed
   - Fewer params = simpler test setup
   - Use Swift's default parameter values to keep the common case simple

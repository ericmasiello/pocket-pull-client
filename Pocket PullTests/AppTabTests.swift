import Testing
@testable import Pocket_Pull

struct AppTabTests {

    @Test func defaultTabIsScan() {
        let defaultTab: AppTab = .scan
        #expect(defaultTab == .scan)
    }

    @Test func hasExpectedCases() {
        let allCases = AppTab.allCases
        #expect(allCases.count == 2)
        #expect(allCases.contains(.scan))
        #expect(allCases.contains(.collection))
    }

    @Test func rawValues() {
        #expect(AppTab.scan.rawValue == "scan")
        #expect(AppTab.collection.rawValue == "collection")
    }
}

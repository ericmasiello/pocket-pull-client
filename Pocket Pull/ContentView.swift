import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .scan

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Scan", systemImage: "barcode.viewfinder", value: .scan) {
                ScanView()
            }

            Tab("Collection", systemImage: "square.grid.2x2", value: .collection) {
                CollectionView()
            }
        }
    }
}

#Preview {
    ContentView()
}

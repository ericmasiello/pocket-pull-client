import SwiftUI

struct ScanView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("Scan")
                .font(.title)
        }
    }
}

#Preview {
    ScanView()
}

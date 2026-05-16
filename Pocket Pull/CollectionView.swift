import SwiftUI

struct CollectionView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("Collection")
                .font(.title)
        }
    }
}

#Preview {
    CollectionView()
}

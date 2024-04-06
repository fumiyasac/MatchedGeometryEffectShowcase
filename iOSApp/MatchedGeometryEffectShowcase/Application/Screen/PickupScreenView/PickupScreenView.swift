import SwiftUI

struct PickupScreenView: View {

    // MARK: - Body

    // MEMO: SwiftUIを利用した「MatchedGeometryEffect」を利用した表現
    var body: some View {
        // MEMO: UIKitのNavigationController表示を実施する
        NavigationStack {
            Group {
                VStack {
                    Text("Pickup")
                }
            }
            // Navigation表示に関する設定
            .navigationTitle("Pickup")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

#Preview {
    PickupScreenView()
}

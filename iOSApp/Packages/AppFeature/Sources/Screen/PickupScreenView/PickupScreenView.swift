import SwiftUI
import Entity
import AppExtension
import Infrastructure
import Common
import Components
import ViewStateProvider

public struct PickupScreenView: View {

    // MARK: - Initializer

    public init() {}

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            Group {
                VStack {
                    Text("Pickup")
                }
            }
            .navigationTitle("Pickup")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

#Preview {
    PickupScreenView()
}

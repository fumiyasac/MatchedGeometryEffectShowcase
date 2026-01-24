import SwiftUI
import Entity
import AppExtension
import Infrastructure
import Common
import Components
import ViewStateProvider

public struct FeedScreenView: View {

    // MARK: - Initializer

    public init() {}

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            Group {
                VStack {
                    Text("Feed")
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FeedScreenView()
}

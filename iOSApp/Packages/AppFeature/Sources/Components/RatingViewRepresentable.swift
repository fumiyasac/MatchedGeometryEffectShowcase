import SwiftUI
import Cosmos
import AppExtension

public struct RatingViewRepresentable: UIViewRepresentable {

    // MARK: - Property

    @Binding var rating: Double

    // MARK: - Initializer

    public init(rating: Binding<Double>) {
        self._rating = rating
    }

    // MARK: - Function

    public func makeUIView(context: Context) -> CosmosView {
        return CosmosView()
    }

    public func updateUIView(_ uiView: CosmosView, context: Context) {
        uiView.rating = rating
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setupCosmosViewSettings(uiView)
    }

    private func setupCosmosViewSettings(_ uiView: CosmosView) {
        uiView.settings.fillMode = .precise
        uiView.settings.starSize = 26
        uiView.settings.emptyBorderWidth = 1.0
        uiView.settings.filledBorderWidth = 1.0
        uiView.settings.emptyBorderColor = .systemYellow
        uiView.settings.filledColor = .systemYellow
        uiView.settings.filledBorderColor = .systemYellow
    }
}

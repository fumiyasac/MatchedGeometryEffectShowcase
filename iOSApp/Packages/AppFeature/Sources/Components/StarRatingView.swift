import SwiftUI
import AppExtension

public struct StarRatingView: View {

    // MARK: - Property

    @State private var rating: Double = 0.0

    // MARK: - Initializer

    public init(rating: Double) {
        _rating = State(initialValue: rating)
    }

    // MARK: - Body

    public var body: some View {
        RatingViewRepresentable(rating: $rating)
    }
}

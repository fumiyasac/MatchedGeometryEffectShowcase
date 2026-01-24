import Foundation

public struct FeaturedEntity {

    // MARK: - Property

    public let identifier: UUID
    public let featuredID: Int
    public let category: String
    public let title: String
    public let catchCopy: String
    public let descriptionText: String
    public let rating: Float
    public let thumbnailUrl: URL?

    // MARK: - Initializer

    public init(
        identifier: UUID = UUID(),
        featuredID: Int,
        category: String,
        title: String,
        catchCopy: String,
        descriptionText: String,
        rating: Float,
        thumbnailUrl: URL?
    ) {
        self.identifier = identifier
        self.featuredID = featuredID
        self.category = category
        self.title = title
        self.catchCopy = catchCopy
        self.descriptionText = descriptionText
        self.rating = rating
        self.thumbnailUrl = thumbnailUrl
    }
}

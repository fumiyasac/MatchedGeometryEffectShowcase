import Foundation

public struct FeaturedEntity: Codable, Identifiable, Equatable {

    public let id: UUID
    public let featuredID: Int
    public let category: String
    public let title: String
    public let catchCopy: String
    public let descriptionText: String
    public let rating: Float
    public let imageName: String

    public init(
        id: UUID = UUID(),
        featuredID: Int,
        category: String,
        title: String,
        catchCopy: String,
        descriptionText: String,
        rating: Float,
        imageName: String
    ) {
        self.id = id
        self.featuredID = featuredID
        self.category = category
        self.title = title
        self.catchCopy = catchCopy
        self.descriptionText = descriptionText
        self.rating = rating
        self.imageName = imageName
    }
}

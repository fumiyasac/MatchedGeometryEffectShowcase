import Foundation

public struct NewsEntity {

    // MARK: - Property

    public let identifier: UUID
    public let newsID: Int
    public let category: String
    public let title: String
    public let descriptionText: String
    public let thumbnailUrl: URL?

    // MARK: - Initializer

    public init(
        identifier: UUID = UUID(),
        newsID: Int,
        category: String,
        title: String,
        descriptionText: String,
        thumbnailUrl: URL?
    ) {
        self.identifier = identifier
        self.newsID = newsID
        self.category = category
        self.title = title
        self.descriptionText = descriptionText
        self.thumbnailUrl = thumbnailUrl
    }
}

import Foundation

public struct NewsEntity: Codable, Identifiable, Equatable {

    public let id: UUID
    public let newsID: Int
    public let category: String
    public let title: String
    public let descriptionText: String
    public let imageName: String

    public init(
        id: UUID = UUID(),
        newsID: Int,
        category: String,
        title: String,
        descriptionText: String,
        imageName: String
    ) {
        self.id = id
        self.newsID = newsID
        self.category = category
        self.title = title
        self.descriptionText = descriptionText
        self.imageName = imageName
    }
}

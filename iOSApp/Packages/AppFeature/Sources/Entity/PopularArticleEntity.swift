import Foundation

public struct PopularArticleEntity: Codable, Identifiable, Equatable {

    public let id: UUID
    public let articleID: Int
    public let articleTitle: String
    public let articleText: String
    public let articleMainCategory: String
    public let articleSubCategory: String
    public let articleHashtags: [String]
    public let imageName: String

    public init(
        id: UUID = UUID(),
        articleID: Int,
        articleTitle: String,
        articleText: String,
        articleMainCategory: String,
        articleSubCategory: String,
        articleHashtags: [String],
        imageName: String
    ) {
        self.id = id
        self.articleID = articleID
        self.articleTitle = articleTitle
        self.articleText = articleText
        self.articleMainCategory = articleMainCategory
        self.articleSubCategory = articleSubCategory
        self.articleHashtags = articleHashtags
        self.imageName = imageName
    }
}

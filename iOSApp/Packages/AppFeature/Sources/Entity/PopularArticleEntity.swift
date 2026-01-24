import Foundation

public struct PopularArticleEntity {

    // MARK: - Property

    public let identifier: UUID
    public let articleID: Int
    public let articleTitle: String
    public let articleText: String
    public let articleMainCategory: String
    public let articleSubCategory: String
    public let articleHashtags: [String]
    public let articlePhotoUrl: URL?

    // MARK: - Initializer

    public init(
        identifier: UUID = UUID(),
        articleID: Int,
        articleTitle: String,
        articleText: String,
        articleMainCategory: String,
        articleSubCategory: String,
        articleHashtags: [String],
        articlePhotoUrl: URL?
    ) {
        self.identifier = identifier
        self.articleID = articleID
        self.articleTitle = articleTitle
        self.articleText = articleText
        self.articleMainCategory = articleMainCategory
        self.articleSubCategory = articleSubCategory
        self.articleHashtags = articleHashtags
        self.articlePhotoUrl = articlePhotoUrl
    }
}

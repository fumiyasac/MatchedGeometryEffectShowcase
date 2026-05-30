import Foundation
import Entity

public struct PopularArticleResponse: Decodable {
    public let id: Int
    public let title: String
    public let articleText: String
    public let mainCategory: String
    public let subCategory: String
    public let hashtags: [String]
    public let imageName: String

    enum CodingKeys: String, CodingKey {
        case id, title, hashtags
        case articleText = "article_text"
        case mainCategory = "main_category"
        case subCategory = "sub_category"
        case imageName = "image_name"
    }

    public func toEntity() -> PopularArticleEntity {
        PopularArticleEntity(
            articleID: id,
            articleTitle: title,
            articleText: articleText,
            articleMainCategory: mainCategory,
            articleSubCategory: subCategory,
            articleHashtags: hashtags,
            imageName: imageName
        )
    }
}

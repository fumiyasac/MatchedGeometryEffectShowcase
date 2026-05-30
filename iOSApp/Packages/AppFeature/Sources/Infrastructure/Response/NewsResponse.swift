import Foundation
import Entity

public struct NewsResponse: Decodable {
    public let id: Int
    public let category: String
    public let title: String
    public let descriptionText: String
    public let imageName: String

    enum CodingKeys: String, CodingKey {
        case id, category, title
        case descriptionText = "description_text"
        case imageName = "image_name"
    }

    public func toEntity() -> NewsEntity {
        NewsEntity(
            newsID: id,
            category: category,
            title: title,
            descriptionText: descriptionText,
            imageName: imageName
        )
    }
}

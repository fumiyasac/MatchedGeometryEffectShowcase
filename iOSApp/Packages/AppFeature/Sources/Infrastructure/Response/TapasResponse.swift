import Foundation
import Entity

public struct TapasResponse: Decodable {

    public let id: Int
    public let title: String
    public let region: String
    public let postedAt: String
    public let authorName: String
    public let catchCopy: String
    public let descriptionText: String
    public let imageName: String

    enum CodingKeys: String, CodingKey {
        case id, title, region
        case postedAt = "posted_at"
        case authorName = "author_name"
        case catchCopy = "catch_copy"
        case descriptionText = "description_text"
        case imageName = "image_name"
    }

    public func toEntity() -> TapasEntity {
        TapasEntity(
            tapasID: id,
            title: title,
            region: region,
            postedAt: postedAt,
            authorName: authorName,
            catchCopy: catchCopy,
            descriptionText: descriptionText,
            imageName: imageName
        )
    }
}

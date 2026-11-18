import Foundation
import Entity

public struct PastaResponse: Decodable {

    public let id: Int
    public let title: String
    public let category: String
    public let catchCopy: String
    public let descriptionText: String
    public let imageName: String

    enum CodingKeys: String, CodingKey {
        case id, title, category
        case catchCopy = "catch_copy"
        case descriptionText = "description_text"
        case imageName = "image_name"
    }

    public func toEntity() -> PastaEntity {
        PastaEntity(
            pastaID: id,
            title: title,
            category: category,
            catchCopy: catchCopy,
            descriptionText: descriptionText,
            imageName: imageName
        )
    }
}

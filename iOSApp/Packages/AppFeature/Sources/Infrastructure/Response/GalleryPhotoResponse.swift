import Foundation
import Entity

public struct GalleryPhotoResponse: Decodable {
    public let id: Int
    public let category: String
    public let title: String
    public let catchCopy: String
    public let descriptionText: String
    public let imageName: String

    enum CodingKeys: String, CodingKey {
        case id, category, title
        case catchCopy = "catch_copy"
        case descriptionText = "description_text"
        case imageName = "image_name"
    }

    public func toEntity() -> GalleryPhotoEntity {
        GalleryPhotoEntity(
            galleryPhotoID: id,
            category: category,
            title: title,
            catchCopy: catchCopy,
            descriptionText: descriptionText,
            imageName: imageName
        )
    }
}

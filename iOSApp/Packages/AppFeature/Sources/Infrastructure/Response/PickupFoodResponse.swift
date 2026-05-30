import Foundation
import Entity

public struct PickupFoodResponse: Decodable {
    public let id: Int
    public let title: String
    public let imageName: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case imageName = "image_name"
    }

    public func toEntity() -> PickupPhotoEntity {
        PickupPhotoEntity(
            pickupPhotoID: id,
            title: title,
            imageName: imageName
        )
    }
}

import Foundation

public struct PickupPhotoEntity: Codable, Identifiable, Equatable {

    public let id: UUID
    public let pickupPhotoID: Int
    public let title: String
    public let imageName: String

    public init(
        id: UUID = UUID(),
        pickupPhotoID: Int,
        title: String,
        imageName: String
    ) {
        self.id = id
        self.pickupPhotoID = pickupPhotoID
        self.title = title
        self.imageName = imageName
    }
}

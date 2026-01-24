import Foundation

public struct PickupPhotoEntity {

    // MARK: - Property

    public let identifier: UUID
    public let pickupPhotoID: Int
    public let title: String
    public let pickupPhotoUrl: URL?

    // MARK: - Initializer

    public init(
        identifier: UUID = UUID(),
        pickupPhotoID: Int,
        title: String,
        pickupPhotoUrl: URL?
    ) {
        self.identifier = identifier
        self.pickupPhotoID = pickupPhotoID
        self.title = title
        self.pickupPhotoUrl = pickupPhotoUrl
    }
}

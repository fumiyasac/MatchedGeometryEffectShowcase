import Foundation

public struct GalleryPhotoEntity {

    // MARK: - Property

    public let identifier: UUID
    public let galleryPhotoID: Int
    public let category: String
    public let title: String
    public let catchCopy: String
    public let descriptionText: String
    public let galleryPhotoUrl: URL?

    // MARK: - Initializer

    public init(
        identifier: UUID = UUID(),
        galleryPhotoID: Int,
        category: String,
        title: String,
        catchCopy: String,
        descriptionText: String,
        galleryPhotoUrl: URL?
    ) {
        self.identifier = identifier
        self.galleryPhotoID = galleryPhotoID
        self.category = category
        self.title = title
        self.catchCopy = catchCopy
        self.descriptionText = descriptionText
        self.galleryPhotoUrl = galleryPhotoUrl
    }
}

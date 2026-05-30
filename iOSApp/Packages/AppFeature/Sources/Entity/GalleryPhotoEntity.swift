import Foundation

public struct GalleryPhotoEntity: Codable, Identifiable, Equatable {

    public let id: UUID
    public let galleryPhotoID: Int
    public let category: String
    public let title: String
    public let catchCopy: String
    public let descriptionText: String
    public let imageName: String

    public init(
        id: UUID = UUID(),
        galleryPhotoID: Int,
        category: String,
        title: String,
        catchCopy: String,
        descriptionText: String,
        imageName: String
    ) {
        self.id = id
        self.galleryPhotoID = galleryPhotoID
        self.category = category
        self.title = title
        self.catchCopy = catchCopy
        self.descriptionText = descriptionText
        self.imageName = imageName
    }
}

import Foundation

public struct TapasEntity: Codable, Identifiable, Equatable, Hashable, Sendable {

    public let id: UUID
    public let tapasID: Int
    public let title: String
    public let region: String
    public let postedAt: String
    public let authorName: String
    public let catchCopy: String
    public let descriptionText: String
    public let imageName: String

    public init(
        id: UUID = UUID(),
        tapasID: Int,
        title: String,
        region: String,
        postedAt: String,
        authorName: String,
        catchCopy: String,
        descriptionText: String,
        imageName: String
    ) {
        self.id = id
        self.tapasID = tapasID
        self.title = title
        self.region = region
        self.postedAt = postedAt
        self.authorName = authorName
        self.catchCopy = catchCopy
        self.descriptionText = descriptionText
        self.imageName = imageName
    }
}

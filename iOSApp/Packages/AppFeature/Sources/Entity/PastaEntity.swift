import Foundation

public struct PastaEntity: Codable, Identifiable, Equatable, Hashable, Sendable {

    public let id: UUID
    public let pastaID: Int
    public let title: String
    public let category: String
    public let catchCopy: String
    public let descriptionText: String
    public let imageName: String

    public init(
        id: UUID = UUID(),
        pastaID: Int,
        title: String,
        category: String,
        catchCopy: String,
        descriptionText: String,
        imageName: String
    ) {
        self.id = id
        self.pastaID = pastaID
        self.title = title
        self.category = category
        self.catchCopy = catchCopy
        self.descriptionText = descriptionText
        self.imageName = imageName
    }
}

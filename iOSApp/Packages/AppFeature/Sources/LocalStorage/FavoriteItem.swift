import Foundation
import SwiftData

@Model
public final class FavoriteItem {

    @Attribute(.unique) public var itemID: Int
    public var itemType: String
    public var title: String
    public var imageName: String
    public var addedAt: Date

    public init(itemID: Int, itemType: String, title: String, imageName: String, addedAt: Date = .now) {
        self.itemID = itemID
        self.itemType = itemType
        self.title = title
        self.imageName = imageName
        self.addedAt = addedAt
    }
}

public enum FavoriteItemType: String {
    case galleryPhoto = "gallery_photo"
    case pickupFood = "pickup_food"
    case popularArticle = "popular_article"
    case product = "product"
    case featured = "featured"
}

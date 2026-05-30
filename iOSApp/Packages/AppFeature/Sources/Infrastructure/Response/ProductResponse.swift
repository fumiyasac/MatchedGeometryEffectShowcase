import Foundation
import Entity

public struct ProductResponse: Decodable {
    public let id: Int
    public let isPremium: Bool
    public let isSale: Bool
    public let percentSale: Int
    public let regularPrice: Int
    public let name: String
    public let summary: String
    public let description: String
    public let mainCategory: String
    public let subCategory: String
    public let hashtags: [String]
    public let imageName: String

    enum CodingKeys: String, CodingKey {
        case id, name, summary, description, hashtags
        case isPremium = "is_premium"
        case isSale = "is_sale"
        case percentSale = "percent_sale"
        case regularPrice = "regular_price"
        case mainCategory = "main_category"
        case subCategory = "sub_category"
        case imageName = "image_name"
    }

    public func toEntity() -> ProductEntity {
        ProductEntity(
            productID: id,
            isPremium: isPremium,
            isSale: isSale,
            percentSale: percentSale,
            regularPrice: regularPrice,
            productName: name,
            productSummary: summary,
            productDescription: description,
            productMainCategory: mainCategory,
            productSubCategory: subCategory,
            productHashtags: hashtags,
            imageName: imageName
        )
    }
}

import Foundation

public struct ProductEntity: Codable, Identifiable, Equatable {

    public let id: UUID
    public let productID: Int
    public let isPremium: Bool
    public let isSale: Bool
    public let percentSale: Int
    public let regularPrice: Int
    public let productName: String
    public let productSummary: String
    public let productDescription: String
    public let productMainCategory: String
    public let productSubCategory: String
    public let productHashtags: [String]
    public let imageName: String

    public var discountedPrice: Int {
        guard isSale, percentSale > 0 else { return regularPrice }
        return regularPrice - (regularPrice * percentSale / 100)
    }

    public init(
        id: UUID = UUID(),
        productID: Int,
        isPremium: Bool,
        isSale: Bool,
        percentSale: Int,
        regularPrice: Int,
        productName: String,
        productSummary: String,
        productDescription: String,
        productMainCategory: String,
        productSubCategory: String,
        productHashtags: [String],
        imageName: String
    ) {
        self.id = id
        self.productID = productID
        self.isPremium = isPremium
        self.isSale = isSale
        self.percentSale = percentSale
        self.regularPrice = regularPrice
        self.productName = productName
        self.productSummary = productSummary
        self.productDescription = productDescription
        self.productMainCategory = productMainCategory
        self.productSubCategory = productSubCategory
        self.productHashtags = productHashtags
        self.imageName = imageName
    }
}

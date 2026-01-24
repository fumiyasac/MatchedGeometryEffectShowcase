import Foundation

public struct ProductEntity {

    // MARK: - Property

    public let identifier: UUID
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
    public let productPhotoUrl: URL?

    // MARK: - Initializer

    public init(
        identifier: UUID = UUID(),
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
        productPhotoUrl: URL?
    ) {
        self.identifier = identifier
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
        self.productPhotoUrl = productPhotoUrl
    }
}

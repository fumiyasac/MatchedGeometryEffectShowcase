import Foundation
import Entity
import Infrastructure

public struct ProductSearchParams {
    public let keyword: String?
    public let mainCategory: String?
    public let subCategory: String?
    public let minPrice: Int?
    public let maxPrice: Int?
    public let isPremium: Bool?
    public let isSale: Bool?
    public let sortBy: String?

    public init(
        keyword: String? = nil,
        mainCategory: String? = nil,
        subCategory: String? = nil,
        minPrice: Int? = nil,
        maxPrice: Int? = nil,
        isPremium: Bool? = nil,
        isSale: Bool? = nil,
        sortBy: String? = nil
    ) {
        self.keyword = keyword
        self.mainCategory = mainCategory
        self.subCategory = subCategory
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.isPremium = isPremium
        self.isSale = isSale
        self.sortBy = sortBy
    }

    var queryParameters: [String: Any] {
        var params: [String: Any] = [:]
        if let keyword, !keyword.isEmpty { params["keyword"] = keyword }
        if let mainCategory { params["main_category"] = mainCategory }
        if let subCategory { params["sub_category"] = subCategory }
        if let minPrice { params["min_price"] = minPrice }
        if let maxPrice { params["max_price"] = maxPrice }
        if let isPremium { params["is_premium"] = isPremium }
        if let isSale { params["is_sale"] = isSale }
        if let sortBy { params["sort_by"] = sortBy }
        return params
    }
}

public protocol ProductRepositoryProtocol {
    func fetchAll(params: ProductSearchParams) async throws -> [ProductEntity]
    func fetchByID(_ id: Int) async throws -> ProductEntity
}

public struct ProductRepository: ProductRepositoryProtocol {

    private let apiClient: ApiClientManager

    public init(apiClient: ApiClientManager = .shared) {
        self.apiClient = apiClient
    }

    public func fetchAll(params: ProductSearchParams = ProductSearchParams()) async throws -> [ProductEntity] {
        let responses = try await apiClient.executeAPIRequest(
            endpointUrl: APIEndpoint.products.url,
            withParameters: params.queryParameters,
            responseFormat: [ProductResponse].self
        )
        return responses.map { $0.toEntity() }
    }

    public func fetchByID(_ id: Int) async throws -> ProductEntity {
        let response = try await apiClient.executeAPIRequest(
            endpointUrl: APIEndpoint.product(id: id).url,
            responseFormat: ProductResponse.self
        )
        return response.toEntity()
    }
}

import Testing
import Foundation
@testable import UseCase
@testable import Entity
@testable import Repository

// MARK: - Mock

final class MockProductRepository: ProductRepositoryProtocol {

    var stubbedProducts: [ProductEntity] = []
    var stubbedProduct: ProductEntity?
    var lastSearchParams: ProductSearchParams?
    var shouldThrow = false

    func fetchAll(params: ProductSearchParams) async throws -> [ProductEntity] {
        if shouldThrow { throw TestError.mock }
        lastSearchParams = params
        return stubbedProducts
    }

    func fetchByID(_ id: Int) async throws -> ProductEntity {
        if shouldThrow { throw TestError.mock }
        guard let product = stubbedProduct else { throw TestError.notFound }
        return product
    }
}

// MARK: - Tests

@Suite("ProductUseCase")
struct ProductUseCaseTests {

    private func makeProduct(id: Int, isPremium: Bool = false, isSale: Bool = false, percentSale: Int = 0, price: Int = 1000) -> ProductEntity {
        ProductEntity(
            productID: id,
            isPremium: isPremium,
            isSale: isSale,
            percentSale: percentSale,
            regularPrice: price,
            productName: "商品 \(id)",
            productSummary: "サマリー",
            productDescription: "説明",
            productMainCategory: "和食",
            productSubCategory: "カレー",
            productHashtags: ["#テスト"],
            imageName: "Additional/additional\(id)"
        )
    }

    @Test("fetchAll passes search params to repository")
    func fetchAllPassesParams() async throws {
        let mock = MockProductRepository()
        mock.stubbedProducts = [makeProduct(id: 1)]
        let useCase = ProductUseCase(repository: mock)
        let params = ProductSearchParams(keyword: "カレー", mainCategory: "和食", isPremium: true)

        let _ = try await useCase.fetchAll(params: params)

        #expect(mock.lastSearchParams?.keyword == "カレー")
        #expect(mock.lastSearchParams?.mainCategory == "和食")
        #expect(mock.lastSearchParams?.isPremium == true)
    }

    @Test("discountedPrice is calculated correctly for sale items")
    func discountedPriceCalculation() {
        let product = makeProduct(id: 1, isSale: true, percentSale: 20, price: 1000)
        #expect(product.discountedPrice == 800)
    }

    @Test("discountedPrice equals regularPrice for non-sale items")
    func noDiscountForNonSaleItems() {
        let product = makeProduct(id: 1, isSale: false, price: 2000)
        #expect(product.discountedPrice == 2000)
    }

    @Test("discountedPrice equals regularPrice when percentSale is 0")
    func noDiscountWhenPercentIsZero() {
        let product = makeProduct(id: 1, isSale: true, percentSale: 0, price: 3000)
        #expect(product.discountedPrice == 3000)
    }

    @Test("fetchAll propagates error from repository")
    func fetchAllThrowsOnRepositoryError() async {
        let mock = MockProductRepository()
        mock.shouldThrow = true
        let useCase = ProductUseCase(repository: mock)

        await #expect(throws: TestError.mock) {
            try await useCase.fetchAll(params: ProductSearchParams())
        }
    }
}

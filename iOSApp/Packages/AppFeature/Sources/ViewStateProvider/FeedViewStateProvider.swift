import Foundation
import Entity
import Infrastructure
import Repository
import UseCase
import LocalStorage

@Observable
public final class FeedViewStateProvider {

    public var featuredList: [FeaturedEntity] = []
    public var newsList: [NewsEntity] = []
    public var productList: [ProductEntity] = []
    public var requestState: APIRequestState = .none
    public var errorMessage: String?

    private let feedUseCase: FeedUseCaseProtocol
    private let productUseCase: ProductUseCaseProtocol

    public init(
        feedUseCase: FeedUseCaseProtocol = FeedUseCase(),
        productUseCase: ProductUseCaseProtocol = ProductUseCase()
    ) {
        self.feedUseCase = feedUseCase
        self.productUseCase = productUseCase
    }

    @MainActor
    public func fetchAll() async {
        requestState = .requesting
        do {
            async let featured = feedUseCase.fetchFeatured()
            async let news = feedUseCase.fetchNews()
            async let products = productUseCase.fetchAll(params: ProductSearchParams())
            (featuredList, newsList, productList) = try await (featured, news, products)
            requestState = .success
        } catch {
            errorMessage = error.localizedDescription
            requestState = .error
            loadMockData()
        }
    }

    private func loadMockData() {
        featuredList = LocalMockDataProvider.featured()
        newsList = LocalMockDataProvider.news()
        productList = LocalMockDataProvider.products()
    }
}

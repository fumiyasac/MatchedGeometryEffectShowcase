import Foundation
import Entity
import Infrastructure
import Repository
import UseCase

@Observable
public final class FeedViewStateProvider {

    public var featuredList: [FeaturedEntity] = []
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
            async let products = productUseCase.fetchAll(params: ProductSearchParams())
            (featuredList, productList) = try await (featured, products)
            requestState = .success
        } catch {
            errorMessage = error.localizedDescription
            requestState = .error
        }
    }
}

import Foundation
import Entity
import Repository

public protocol FeedUseCaseProtocol {
    func fetchFeatured() async throws -> [FeaturedEntity]
}

public struct FeedUseCase: FeedUseCaseProtocol {

    private let featuredRepository: FeaturedRepositoryProtocol

    public init(
        featuredRepository: FeaturedRepositoryProtocol = FeaturedRepository(),
    ) {
        self.featuredRepository = featuredRepository
    }

    public func fetchFeatured() async throws -> [FeaturedEntity] {
        try await featuredRepository.fetchAll()
    }
}

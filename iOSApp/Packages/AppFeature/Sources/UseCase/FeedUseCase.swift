import Foundation
import Entity
import Repository

public protocol FeedUseCaseProtocol {
    func fetchFeatured() async throws -> [FeaturedEntity]
    func fetchNews() async throws -> [NewsEntity]
}

public struct FeedUseCase: FeedUseCaseProtocol {

    private let featuredRepository: FeaturedRepositoryProtocol
    private let newsRepository: NewsRepositoryProtocol

    public init(
        featuredRepository: FeaturedRepositoryProtocol = FeaturedRepository(),
        newsRepository: NewsRepositoryProtocol = NewsRepository()
    ) {
        self.featuredRepository = featuredRepository
        self.newsRepository = newsRepository
    }

    public func fetchFeatured() async throws -> [FeaturedEntity] {
        try await featuredRepository.fetchAll()
    }

    public func fetchNews() async throws -> [NewsEntity] {
        try await newsRepository.fetchAll()
    }
}

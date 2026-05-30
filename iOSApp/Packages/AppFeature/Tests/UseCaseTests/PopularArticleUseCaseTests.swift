import Testing
import Foundation
@testable import UseCase
@testable import Entity
@testable import Repository

// MARK: - Mock

final class MockPopularArticleRepository: PopularArticleRepositoryProtocol {

    var stubbedArticles: [PopularArticleEntity] = []
    var stubbedArticle: PopularArticleEntity?
    var shouldThrow = false

    func fetchAll() async throws -> [PopularArticleEntity] {
        if shouldThrow { throw TestError.mock }
        return stubbedArticles
    }

    func fetchByID(_ id: Int) async throws -> PopularArticleEntity {
        if shouldThrow { throw TestError.mock }
        guard let article = stubbedArticle else { throw TestError.notFound }
        return article
    }
}

// MARK: - Tests

@Suite("PopularArticleUseCase")
struct PopularArticleUseCaseTests {

    private func makeArticle(id: Int) -> PopularArticleEntity {
        PopularArticleEntity(
            articleID: id,
            articleTitle: "記事タイトル \(id)",
            articleText: "本文テキスト",
            articleMainCategory: "洋食",
            articleSubCategory: "パスタ",
            articleHashtags: ["#洋食", "#パスタ"],
            imageName: "FeaturedPhoto/featured_\(id)"
        )
    }

    @Test("fetchAll returns all articles")
    func fetchAllReturnsArticles() async throws {
        let mock = MockPopularArticleRepository()
        mock.stubbedArticles = (1...12).map { makeArticle(id: $0) }
        let useCase = PopularArticleUseCase(repository: mock)

        let result = try await useCase.fetchAll()

        #expect(result.count == 12)
        #expect(result.first?.imageName == "FeaturedPhoto/featured_1")
    }

    @Test("fetchByID returns article with hashtags")
    func fetchByIDReturnsArticleWithHashtags() async throws {
        let mock = MockPopularArticleRepository()
        mock.stubbedArticle = makeArticle(id: 3)
        let useCase = PopularArticleUseCase(repository: mock)

        let result = try await useCase.fetchByID(3)

        #expect(result.articleID == 3)
        #expect(result.articleHashtags.contains("#洋食"))
        #expect(result.articleHashtags.contains("#パスタ"))
    }

    @Test("fetchAll returns empty when repository is empty")
    func fetchAllReturnsEmpty() async throws {
        let mock = MockPopularArticleRepository()
        let useCase = PopularArticleUseCase(repository: mock)

        let result = try await useCase.fetchAll()

        #expect(result.isEmpty)
    }
}

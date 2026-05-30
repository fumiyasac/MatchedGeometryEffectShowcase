import Foundation
import Entity
import Infrastructure

public protocol PopularArticleRepositoryProtocol {
    func fetchAll() async throws -> [PopularArticleEntity]
    func fetchByID(_ id: Int) async throws -> PopularArticleEntity
}

public struct PopularArticleRepository: PopularArticleRepositoryProtocol {

    private let apiClient: ApiClientManager

    public init(apiClient: ApiClientManager = .shared) {
        self.apiClient = apiClient
    }

    public func fetchAll() async throws -> [PopularArticleEntity] {
        let responses = try await apiClient.executeAPIRequest(
            endpointUrl: APIEndpoint.popularArticles.url,
            responseFormat: [PopularArticleResponse].self
        )
        return responses.map { $0.toEntity() }
    }

    public func fetchByID(_ id: Int) async throws -> PopularArticleEntity {
        let response = try await apiClient.executeAPIRequest(
            endpointUrl: APIEndpoint.popularArticle(id: id).url,
            responseFormat: PopularArticleResponse.self
        )
        return response.toEntity()
    }
}

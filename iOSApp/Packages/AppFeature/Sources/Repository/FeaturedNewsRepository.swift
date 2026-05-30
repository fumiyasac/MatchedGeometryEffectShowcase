import Foundation
import Entity
import Infrastructure

public protocol FeaturedRepositoryProtocol {
    func fetchAll() async throws -> [FeaturedEntity]
}

public protocol NewsRepositoryProtocol {
    func fetchAll() async throws -> [NewsEntity]
}

public struct FeaturedRepository: FeaturedRepositoryProtocol {

    private let apiClient: ApiClientManager

    public init(apiClient: ApiClientManager = .shared) {
        self.apiClient = apiClient
    }

    public func fetchAll() async throws -> [FeaturedEntity] {
        let responses = try await apiClient.executeAPIRequest(
            endpointUrl: APIEndpoint.featured.url,
            responseFormat: [FeaturedResponse].self
        )
        return responses.map { $0.toEntity() }
    }
}

public struct NewsRepository: NewsRepositoryProtocol {

    private let apiClient: ApiClientManager

    public init(apiClient: ApiClientManager = .shared) {
        self.apiClient = apiClient
    }

    public func fetchAll() async throws -> [NewsEntity] {
        let responses = try await apiClient.executeAPIRequest(
            endpointUrl: APIEndpoint.news.url,
            responseFormat: [NewsResponse].self
        )
        return responses.map { $0.toEntity() }
    }
}

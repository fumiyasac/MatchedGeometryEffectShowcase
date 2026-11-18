import Foundation
import Entity
import Infrastructure

public protocol FeaturedRepositoryProtocol {
    func fetchAll() async throws -> [FeaturedEntity]
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

import Foundation
import Entity
import Infrastructure

public protocol PickupRepositoryProtocol {
    func fetchAll() async throws -> [PickupPhotoEntity]
}

public struct PickupRepository: PickupRepositoryProtocol {

    private let apiClient: ApiClientManager

    public init(apiClient: ApiClientManager = .shared) {
        self.apiClient = apiClient
    }

    public func fetchAll() async throws -> [PickupPhotoEntity] {
        let responses = try await apiClient.executeAPIRequest(
            endpointUrl: APIEndpoint.pickupFoods.url,
            responseFormat: [PickupFoodResponse].self
        )
        return responses.map { $0.toEntity() }
    }
}

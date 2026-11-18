import Foundation
import Entity
import Infrastructure

public protocol TapasRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [TapasEntity]
    func fetchByID(_ id: Int) async throws -> TapasEntity
}

public struct TapasRepository: TapasRepositoryProtocol {

    private let apiClient: ApiClientManager

    public init(apiClient: ApiClientManager = .shared) {
        self.apiClient = apiClient
    }

    public func fetchAll() async throws -> [TapasEntity] {
        do {
            let responses = try await apiClient.executeAPIRequest(
                endpointUrl: APIEndpoint.tapas.url,
                responseFormat: [TapasResponse].self
            )
            return responses.map { $0.toEntity() }
        } catch {
            try? await Task.sleep(nanoseconds: 300_000_000)
            return TapasMockData.all
        }
    }

    public func fetchByID(_ id: Int) async throws -> TapasEntity {
        do {
            let response = try await apiClient.executeAPIRequest(
                endpointUrl: APIEndpoint.tapasItem(id: id).url,
                responseFormat: TapasResponse.self
            )
            return response.toEntity()
        } catch {
            guard let hit = TapasMockData.all.first(where: { $0.tapasID == id }) else { throw error }
            return hit
        }
    }
}

import Foundation
import Entity
import Infrastructure

public protocol PastaRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [PastaEntity]
    func fetchByID(_ id: Int) async throws -> PastaEntity
}

public struct PastaRepository: PastaRepositoryProtocol {

    private let apiClient: ApiClientManager

    public init(apiClient: ApiClientManager = .shared) {
        self.apiClient = apiClient
    }

    public func fetchAll() async throws -> [PastaEntity] {
        do {
            let responses = try await apiClient.executeAPIRequest(
                endpointUrl: APIEndpoint.pastas.url,
                responseFormat: [PastaResponse].self
            )
            return responses.map { $0.toEntity() }
        } catch {
            // MEMO: モックAPI未起動時のフォールバック（ダミーJSON相当のローカルデータ）
            try? await Task.sleep(nanoseconds: 300_000_000)
            return PastaMockData.all
        }
    }

    public func fetchByID(_ id: Int) async throws -> PastaEntity {
        do {
            let response = try await apiClient.executeAPIRequest(
                endpointUrl: APIEndpoint.pasta(id: id).url,
                responseFormat: PastaResponse.self
            )
            return response.toEntity()
        } catch {
            guard let hit = PastaMockData.all.first(where: { $0.pastaID == id }) else { throw error }
            return hit
        }
    }
}

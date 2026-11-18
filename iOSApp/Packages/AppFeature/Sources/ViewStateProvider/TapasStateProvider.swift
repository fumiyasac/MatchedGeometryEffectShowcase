import Foundation
import Entity
import Infrastructure
import UseCase

@Observable
@MainActor
public final class TapasStateProvider {

    public var tapasList: [TapasEntity] = []
    public var selectedTapas: TapasEntity?
    public var requestState: APIRequestState = .none
    public var errorMessage: String?

    private let useCase: TapasUseCaseProtocol

    public init(useCase: TapasUseCaseProtocol = TapasUseCase()) {
        self.useCase = useCase
    }

    public func fetchAll() async {
        requestState = .requesting
        do {
            tapasList = try await useCase.fetchAll()
            requestState = .success
        } catch {
            errorMessage = error.localizedDescription
            requestState = .error
        }
    }
}

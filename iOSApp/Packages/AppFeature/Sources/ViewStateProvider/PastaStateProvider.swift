import Foundation
import Entity
import Infrastructure
import UseCase

@Observable
@MainActor
public final class PastaStateProvider {

    public var pastaList: [PastaEntity] = []
    public var selectedPasta: PastaEntity?
    public var requestState: APIRequestState = .none
    public var errorMessage: String?

    private let useCase: PastaUseCaseProtocol

    public init(useCase: PastaUseCaseProtocol = PastaUseCase()) {
        self.useCase = useCase
    }

    public func fetchAll() async {
        requestState = .requesting
        do {
            pastaList = try await useCase.fetchAll()
            requestState = .success
        } catch {
            errorMessage = error.localizedDescription
            requestState = .error
        }
    }
}

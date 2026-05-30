import Foundation
import Entity
import Infrastructure
import UseCase
import LocalStorage

@Observable
public final class PickupViewStateProvider {

    public var pickupList: [PickupPhotoEntity] = []
    public var requestState: APIRequestState = .none
    public var errorMessage: String?

    private let useCase: PickupUseCaseProtocol

    public init(useCase: PickupUseCaseProtocol = PickupUseCase()) {
        self.useCase = useCase
    }

    @MainActor
    public func fetchAll() async {
        requestState = .requesting
        do {
            pickupList = try await useCase.fetchAll()
            requestState = .success
        } catch {
            errorMessage = error.localizedDescription
            requestState = .error
            pickupList = LocalMockDataProvider.pickupFoods()
        }
    }
}

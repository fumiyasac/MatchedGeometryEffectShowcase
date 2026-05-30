import Foundation
import Entity
import Infrastructure
import UseCase
import LocalStorage

@Observable
public final class GalleryStateProvider {

    public var photoList: [GalleryPhotoEntity] = []
    public var selectedPhoto: GalleryPhotoEntity?
    public var requestState: APIRequestState = .none
    public var errorMessage: String?

    private let useCase: GalleryUseCaseProtocol

    public init(useCase: GalleryUseCaseProtocol = GalleryUseCase()) {
        self.useCase = useCase
    }

    @MainActor
    public func fetchAll() async {
        requestState = .requesting
        do {
            photoList = try await useCase.fetchAll()
            requestState = .success
        } catch {
            errorMessage = error.localizedDescription
            requestState = .error
            photoList = LocalMockDataProvider.galleryPhotos()
        }
    }
}

import Foundation
import Entity
import Infrastructure
import UseCase
import LocalStorage

@Observable
public final class PopularViewStateProvider {

    public var articleList: [PopularArticleEntity] = []
    public var selectedArticle: PopularArticleEntity?
    public var requestState: APIRequestState = .none
    public var errorMessage: String?

    private let useCase: PopularArticleUseCaseProtocol

    public init(useCase: PopularArticleUseCaseProtocol = PopularArticleUseCase()) {
        self.useCase = useCase
    }

    @MainActor
    public func fetchAll() async {
        requestState = .requesting
        do {
            articleList = try await useCase.fetchAll()
            requestState = .success
        } catch {
            errorMessage = error.localizedDescription
            requestState = .error
            articleList = LocalMockDataProvider.popularArticles()
        }
    }

    @MainActor
    public func fetchDetail(id: Int) async {
        do {
            selectedArticle = try await useCase.fetchByID(id)
        } catch {
            selectedArticle = articleList.first { $0.articleID == id }
        }
    }
}

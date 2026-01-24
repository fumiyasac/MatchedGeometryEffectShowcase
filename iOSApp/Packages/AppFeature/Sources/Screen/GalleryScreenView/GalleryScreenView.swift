import SwiftUI
import Entity
import AppExtension
import Infrastructure
import Common
import Components
import ViewStateProvider

public struct GalleryScreenView: View {

    // MARK: - Initializer

    public init() {}

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            GalleryScreenClassicView()
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.top)
        }
    }
}

// MARK: - Preview

#Preview {
    GalleryScreenView()
}

// MARK: - UIViewControllerRepresentable

struct GalleryScreenClassicView: UIViewControllerRepresentable {

    // MARK: - Function

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.pushViewController(
            UIStoryboard(name: "GalleryScreenViewController", bundle: Bundle.module).instantiateInitialViewController()!,
            animated: false
        )
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    // MARK: - Class (Coodinator)

    class Coordinator {}
}

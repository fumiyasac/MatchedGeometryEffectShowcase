import SwiftUI
import Entity
import AppExtension
import Infrastructure
import Common
import Components
import ViewStateProvider

public struct PopularScreenView: View {

    // MARK: - Initializer

    public init() {}

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            PopularScreenClassicView()
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.top)
        }
    }
}

// MARK: - Preview

#Preview {
    PopularScreenView()
}

// MARK: - UIViewControllerRepresentable

struct PopularScreenClassicView: UIViewControllerRepresentable {

    // MARK: - Function

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.pushViewController(
            PopularScreenViewController.instantiate(),
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

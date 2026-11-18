import SwiftUI
import UIKit
import AppExtension

// MARK: - SwiftUI Entry Point

public struct PastaGalleryScreenView: View {

    public init() {}

    public var body: some View {
        PastaGalleryHostingView()
            .ignoresSafeArea(edges: .top)
    }
}

// MARK: - UIViewControllerRepresentable

struct PastaGalleryHostingView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.pushViewController(
            PastaGalleryViewController.instantiate(),
            animated: false
        )
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

// MARK: - Preview

#Preview {
    PastaGalleryScreenView()
}

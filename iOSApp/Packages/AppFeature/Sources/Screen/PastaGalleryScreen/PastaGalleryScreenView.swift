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
// MEMO: カスタムトランジション付きの UINavigationController をホストする

struct PastaGalleryHostingView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> PastaGalleryNavigationController {
        let navigationController = PastaGalleryNavigationController()
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.pushViewController(
            PastaGalleryViewController.instantiate(),
            animated: false
        )
        return navigationController
    }

    func updateUIViewController(_ uiViewController: PastaGalleryNavigationController, context: Context) {}
}

// MARK: - Preview

#Preview {
    PastaGalleryScreenView()
}

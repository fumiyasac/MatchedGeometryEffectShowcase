import SwiftUI

struct GalleryScreenView: View {

    // MARK: - Body

    // MEMO: GalleryScreenViewControllerを利用した「CustomTransition」を利用した表現
    var body: some View {
        NavigationStack {
            // MEMO: 画面全体をNavigationStack内に記載しているが、画面遷移処理自体はUINavigationBarで実施する
            // 👉 NavigationStackのNavigationを隠し上方向のSafeAreaを無視して調整をしている
            // ※ GalleryScreenViewControllerの処理を前提としたい画面の際に利用する想定
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

// MEMO: GalleryScreenViewControllerを表示するための処理
// 参考: UIKit製の画面とブリッジする処理はこちらを参考にしています。
// https://qiita.com/yimajo/items/791dc1c1693d9821c5a8

struct GalleryScreenClassicView: UIViewControllerRepresentable {

    // MARK: - Function

    // MEMO: UIViewRepresentableで提供されているメソッドと微妙に違う点に注意。
    func makeUIViewController(context: Context) -> UINavigationController {

        // MEMO: 表示対象の画面クラスをセットしたUINavigationControllerを返す
        let navigationController = UINavigationController()
        navigationController.pushViewController(
            UIStoryboard(name: "GalleryScreenViewController", bundle: nil).instantiateInitialViewController()!,
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

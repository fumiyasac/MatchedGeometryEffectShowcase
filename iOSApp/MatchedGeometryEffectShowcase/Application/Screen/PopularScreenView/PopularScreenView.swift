import SwiftUI

struct PopularScreenView: View {

    // MARK: - Body

    // MEMO: PopularScreenViewControllerを利用した「CustomTransition」を利用した表現
    var body: some View {
        NavigationStack {
            // MEMO: 画面全体をNavigationStack内に記載しているが、画面遷移処理自体はUINavigationBarで実施する
            // 👉 NavigationStackのNavigationを隠し上方向のSafeAreaを無視して調整をしている
            // ※ PopularScreenViewControllerの処理を前提としたい画面の際に利用する想定
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

// MEMO: PopularScreenViewControllerを表示するための処理
// 参考: UIKit製の画面とブリッジする処理はこちらを参考にしています。
// https://qiita.com/yimajo/items/791dc1c1693d9821c5a8
// https://dev.classmethod.jp/articles/tried-swiftui-tutorial-secondpart/
// 補足: PHPickerViewControllerをUIViewControllerRepresentableを利用する例
// https://www.hackingwithswift.com/books/ios-swiftui/using-coordinators-to-manage-swiftui-view-controllers

struct PopularScreenClassicView: UIViewControllerRepresentable {

    // MARK: - Function

    // MEMO: UIViewRepresentableで提供されているメソッドと微妙に違う点に注意。
    // ※ こちらが実行されるのは1回のみ。（以降は`updateUIViewController(_ uiViewController: context:)`が呼ばれる）
    func makeUIViewController(context: Context) -> UINavigationController {

        // MEMO: 表示対象の画面クラスをセットしたUINavigationControllerを返す
        let navigationController = UINavigationController()
        navigationController.pushViewController(
            UIStoryboard(name: "PopularScreenViewController", bundle: nil).instantiateInitialViewController()!,
            animated: false
        )
        return navigationController
    }

    // MEMO: 今回は処理を追加する必要はないが、Viewが更新された際に当該ViewControllerに何らかの処理を実行する場合に追加する。
    // ※ SwiftUIでの状態変化が生じたタイミングで、処理をUIViewControllerへ伝える
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

    // MEMO: Coordinatorクラスをインスタンス化する。
    // ※ makeUIViewController(context:)の前に呼び出される
    // 参考: UIViewRepresentableの使い方！Coordinatorクラスとは？
    // https://appdev-room.com/swift-uiviewrepresentable
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    // MARK: - Class (Coodinator)

    class Coordinator {}
}


import Foundation
import SwiftUI

public struct ToastModifier: ViewModifier {
    
    // MARK: - Property

    // MEMO: Toast表示用のインスタンスを格納する変数
    @Binding var simpleToast: SimpleToast?
    // MEMO: 表示コントロール用の変数
    @State private var workItem: DispatchWorkItem?

    // MARK: - Function
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainSimpleToastView()
                        .offset(y: 32)
                }
                .animation(.spring(), value: simpleToast)
            )
            .onChange(of: simpleToast) {
                showToast()
            }
    }

    // MARK: - Function

    @ViewBuilder public func mainSimpleToastView() -> some View {
        if let toast = simpleToast {
            VStack {
                // MEMO: Toast表示処理を実行する
                SimpleToastView(
                    style: toast.style,
                    message: toast.message,
                    width: toast.width
                ) {
                    dismissToast()
                }
                Spacer()
            }
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.1)))
        }
    }

    // MARK: - Private Function

    private func showToast() {
        guard let toast = simpleToast else {
            return
        }
        // MEMO: HapticFeedbackを表示時に付与する
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        // MEMO: Durationが0より大きい場合（すなわち表示途中のものが残っている場合）は一旦綺麗にしてから再度実行する
        if toast.duration > 0 {
            workItem?.cancel()
            let task = DispatchWorkItem {
                dismissToast()
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }

    private func dismissToast() {
        // MEMO: Animationを伴って閉じる様な形を取る
        withAnimation {
            simpleToast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

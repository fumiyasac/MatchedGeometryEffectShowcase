import Foundation
import SwiftUI

public struct ToastModifier: ViewModifier {
    
    // MARK: - Property

    //
    @Binding var simpleToast: SimpleToast?
    //
    @State private var workItem: DispatchWorkItem?
    
    // MARK: - Function
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainSimpleToastView()
                        .offset(y: 32)
                }.animation(.spring(), value: simpleToast)
            )
            .onChange(of: simpleToast) {
                showToast()
            }
    }

    // MARK: - Function

    @ViewBuilder public func mainSimpleToastView() -> some View {
        if let toast = simpleToast {
            VStack {
                //
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
        //
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        //
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
        //
        withAnimation {
            simpleToast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

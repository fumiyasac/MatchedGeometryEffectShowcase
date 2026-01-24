import SwiftUI

// MARK: - Extension

public extension View {

    // MARK: - Function

    func onFirstAppear(_ onceAction: @escaping () -> Void) -> some View {
        modifier(FirstAppear(onceAction: onceAction))
    }
}

// MARK: - ViewModifier

private struct FirstAppear: ViewModifier {

    // MARK: - Property

    private let onceAction: () -> Void

    @State private var hasAppeared = false

    // MARK: - Initializer

    init(onceAction: @escaping () -> Void) {
        self.onceAction = onceAction
        _hasAppeared = State(initialValue: false)
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else {
                return
            }
            hasAppeared = true
            onceAction()
        }
    }
}

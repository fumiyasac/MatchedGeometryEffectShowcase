import UIKit

final class GalleryDismissInteractor: UIPercentDrivenInteractiveTransition {

    var isInteracting = false
    private weak var viewController: UIViewController?
    private let animator: GalleryPresentAnimator

    init(animator: GalleryPresentAnimator) {
        self.animator = animator
    }

    func attach(to viewController: UIViewController) {
        self.viewController = viewController
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        viewController.view.addGestureRecognizer(pan)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: view)
        let progress = min(max(translation.y / view.bounds.height, 0), 1)

        switch gesture.state {
        case .began where translation.y > 0:
            isInteracting = true
            viewController?.dismiss(animated: true)
        case .changed:
            update(progress)
        case .ended:
            isInteracting = false
            if progress > 0.35 { finish() } else { cancel() }
        default:
            isInteracting = false
            cancel()
        }
    }
}

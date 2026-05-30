import UIKit

final class PopularInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var isInteracting = false
    private weak var viewController: UIViewController?

    func attach(to viewController: UIViewController) {
        self.viewController = viewController
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.edges = .left
        viewController.view.addGestureRecognizer(pan)
    }

    @objc private func handlePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: view)
        let progress = min(max(translation.x / view.bounds.width, 0), 1)

        switch gesture.state {
        case .began:
            isInteracting = true
            viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            update(progress)
        case .ended:
            isInteracting = false
            if progress > 0.4 { finish() } else { cancel() }
        default:
            isInteracting = false
            cancel()
        }
    }
}

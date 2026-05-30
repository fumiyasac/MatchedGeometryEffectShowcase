import UIKit

final class GalleryPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    enum Direction { case present, dismiss }
    private let direction: Direction
    private let duration: TimeInterval = 0.42
    var sourceFrame: CGRect = .zero

    init(direction: Direction) {
        self.direction = direction
    }

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        switch direction {
        case .present: animatePresent(using: transitionContext)
        case .dismiss: animateDismiss(using: transitionContext)
        }
    }

    private func animatePresent(using ctx: any UIViewControllerContextTransitioning) {
        guard let toVC = ctx.viewController(forKey: .to) else { return }
        let container = ctx.containerView
        let finalFrame = ctx.finalFrame(for: toVC)

        toVC.view.frame = sourceFrame.isEmpty ? finalFrame.offsetBy(dx: 0, dy: container.bounds.height) : sourceFrame
        toVC.view.alpha = 0
        toVC.view.layer.cornerRadius = 16
        container.addSubview(toVC.view)

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.2) {
            toVC.view.frame = finalFrame
            toVC.view.alpha = 1
            toVC.view.layer.cornerRadius = 0
        } completion: { _ in
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }

    private func animateDismiss(using ctx: any UIViewControllerContextTransitioning) {
        guard let fromVC = ctx.viewController(forKey: .from) else { return }
        let target = sourceFrame.isEmpty ? fromVC.view.frame.offsetBy(dx: 0, dy: fromVC.view.bounds.height) : sourceFrame

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.2) {
            fromVC.view.frame = target
            fromVC.view.alpha = 0
            fromVC.view.layer.cornerRadius = 16
        } completion: { _ in
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }
}

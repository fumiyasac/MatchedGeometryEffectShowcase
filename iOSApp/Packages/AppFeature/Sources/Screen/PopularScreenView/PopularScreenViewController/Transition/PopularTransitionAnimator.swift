import UIKit

final class PopularTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    enum Direction {
        case push, pop
    }

    private let direction: Direction
    private let duration: TimeInterval = 0.36

    init(direction: Direction) {
        self.direction = direction
    }

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        switch direction {
        case .push: animatePush(using: transitionContext)
        case .pop:  animatePop(using: transitionContext)
        }
    }

    private func animatePush(using ctx: any UIViewControllerContextTransitioning) {
        guard let toVC = ctx.viewController(forKey: .to) else { return }
        let container = ctx.containerView
        let finalFrame = ctx.finalFrame(for: toVC)

        toVC.view.frame = finalFrame.offsetBy(dx: container.bounds.width, dy: 0)
        container.addSubview(toVC.view)

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2) {
            toVC.view.frame = finalFrame
        } completion: { _ in
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }

    private func animatePop(using ctx: any UIViewControllerContextTransitioning) {
        guard let fromVC = ctx.viewController(forKey: .from),
              let toVC = ctx.viewController(forKey: .to) else { return }
        let container = ctx.containerView
        container.insertSubview(toVC.view, belowSubview: fromVC.view)

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2) {
            fromVC.view.frame = fromVC.view.frame.offsetBy(dx: container.bounds.width, dy: 0)
        } completion: { _ in
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }
}

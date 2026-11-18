import UIKit

// MARK: - Fluid Photo Gallery風 カスタムトランジション
// 選択セルの位置から詳細画面を滑らかに拡大 / 縮小 で魅せる Present / Dismiss Animator

final class PastaPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    enum Direction { case present, dismiss }

    private let direction: Direction
    private let duration: TimeInterval = 0.45

    var sourceFrame: CGRect = .zero
    var sourceImage: UIImage?

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

    // MARK: - Present

    private func animatePresent(using ctx: any UIViewControllerContextTransitioning) {
        guard let toVC = ctx.viewController(forKey: .to) else { return }
        let container = ctx.containerView
        let finalFrame = ctx.finalFrame(for: toVC)

        // 元のセル位置からスケールアップ風に拡大する
        toVC.view.frame = sourceFrame.isEmpty ? finalFrame.offsetBy(dx: 0, dy: container.bounds.height) : sourceFrame
        toVC.view.alpha = 0
        toVC.view.layer.cornerRadius = 16
        toVC.view.layer.masksToBounds = true
        container.addSubview(toVC.view)

        // 元のセル画像を上に重ねてクロスフェード感を演出
        let overlayImageView: UIImageView? = {
            guard let image = sourceImage, !sourceFrame.isEmpty else { return nil }
            let iv = UIImageView(image: image)
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.frame = sourceFrame
            iv.layer.cornerRadius = 10
            container.addSubview(iv)
            return iv
        }()

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.88, initialSpringVelocity: 0.15) {
            toVC.view.frame = finalFrame
            toVC.view.alpha = 1
            toVC.view.layer.cornerRadius = 0
            overlayImageView?.frame = CGRect(x: 0, y: 0, width: finalFrame.width, height: 360)
            overlayImageView?.alpha = 0
            overlayImageView?.layer.cornerRadius = 0
        } completion: { _ in
            overlayImageView?.removeFromSuperview()
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }

    // MARK: - Dismiss

    private func animateDismiss(using ctx: any UIViewControllerContextTransitioning) {
        guard let fromVC = ctx.viewController(forKey: .from) else { return }
        let target = sourceFrame.isEmpty ? fromVC.view.frame.offsetBy(dx: 0, dy: fromVC.view.bounds.height) : sourceFrame

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.15) {
            fromVC.view.frame = target
            fromVC.view.alpha = 0
            fromVC.view.layer.cornerRadius = 16
        } completion: { _ in
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }
}

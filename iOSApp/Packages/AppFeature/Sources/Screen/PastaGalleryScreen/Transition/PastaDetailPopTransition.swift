import Foundation
import UIKit

// MARK: - UINavigationController Pop遷移時のカスタムトランジション
// 詳細画面のUIImageViewから、Grid上のサムネイル位置へ戻る表現を実現する

final class PastaDetailPopTransition: NSObject {

    // MARK: - Property

    private let toDelegate: PastaDetailTransitionAnimatorDelegate
    private let photoDetailVC: PastaDetailViewController

    private let transitionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.accessibilityIgnoresInvertColors = true
        return iv
    }()

    // MARK: - Initializer

    init?(toDelegate: Any, fromPhotoDetailVC photoDetailVC: PastaDetailViewController) {
        guard let toDelegate = toDelegate as? PastaDetailTransitionAnimatorDelegate else {
            return nil
        }
        self.toDelegate = toDelegate
        self.photoDetailVC = photoDetailVC
    }

    // MARK: - Static Function

    // 戻り先が見つからなかった場合のダミーfram値（画面下に逃がす）
    static func defaultOffscreenFrameForDismissal(transitionImageSize: CGSize, screenHeight: CGFloat) -> CGRect {
        CGRect(x: 0, y: screenHeight, width: transitionImageSize.width, height: transitionImageSize.height)
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PastaDetailPopTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.24
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        containerView.addSubview(toView)

        let transitionImage = photoDetailVC.referenceImage()!
        transitionImageView.image = transitionImage
        transitionImageView.frame = photoDetailVC.imageFrame()!
        containerView.addSubview(transitionImageView)

        photoDetailVC.transitionWillStart()
        toDelegate.transitionWillStart()

        let fromReferenceFrame = photoDetailVC.imageFrame()!

        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.93) {
            fromView.alpha = 0
        }

        animator.addCompletion { _ in
            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.toDelegate.transitionDidEnd()
            self.photoDetailVC.transitionDidEnd()
        }

        animator.startAnimation()

        // MEMO: 遷移元(Grid)のレイアウトが更新されて正しいセル座標が得られるまで少し待つ
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            animator.addAnimations {
                if let toReferenceFrame = self.toDelegate.imageFrame() {
                    self.transitionImageView.frame = toReferenceFrame
                } else {
                    self.transitionImageView.frame = PastaDetailPopTransition.defaultOffscreenFrameForDismissal(
                        transitionImageSize: fromReferenceFrame.size,
                        screenHeight: containerView.bounds.height
                    )
                }
            }
        }
    }
}

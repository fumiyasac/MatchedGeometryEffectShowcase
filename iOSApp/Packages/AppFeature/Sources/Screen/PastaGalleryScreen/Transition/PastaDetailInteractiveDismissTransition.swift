import Foundation
import UIKit
import AppExtension

// MARK: - Pan Gestureによるインタラクティブな Pop 遷移
// 下方向へのドラッグに応じて画像が縮小・追従し、指を離したタイミングの進捗で完了/キャンセルを判定する

final class PastaDetailInteractiveDismissTransition: NSObject {

    // MARK: - Property

    private let fromDelegate: PastaDetailTransitionAnimatorDelegate
    private weak var toDelegate: PastaDetailTransitionAnimatorDelegate?

    private var fromReferenceImageViewFrame: CGRect? = nil
    private var toReferenceImageViewFrame: CGRect? = nil

    private var currentBackgroundAnimation: UIViewPropertyAnimator? = nil
    private var currentTransitionContext: UIViewControllerContextTransitioning? = nil

    private let currentTransitionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.accessibilityIgnoresInvertColors = true
        return iv
    }()

    // MARK: - Initializer

    init(fromDelegate: PastaDetailViewController, toDelegate: Any) {
        self.fromDelegate = fromDelegate
        self.toDelegate = toDelegate as? PastaDetailTransitionAnimatorDelegate
        super.init()
    }

    // MARK: - Function

    // PhotoDetailViewController側で実行されたPanGestureRecognizerと連動した処理
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        guard let transitionContext = currentTransitionContext else { return }
        let transitionImageView = currentTransitionImageView

        let translation = gestureRecognizer.translation(in: nil)
        let translationVertical = translation.y

        let percentageComplete = getPercentageComplete(forVerticalDrag: translationVertical)
        let transitionImageScale = getTransitionImageScaleFor(percentageComplete: percentageComplete)

        switch gestureRecognizer.state {
        case .cancelled, .failed:
            completeTransition(didCancel: true)

        case .changed:
            transitionImageView.transform = CGAffineTransform.identity
                .scaledBy(x: transitionImageScale, y: transitionImageScale)
                .translatedBy(x: translation.x, y: translation.y)
            transitionContext.updateInteractiveTransition(percentageComplete)
            currentBackgroundAnimation?.fractionComplete = percentageComplete

        case .ended:
            let fingerIsMovingDownwards = gestureRecognizer.velocity(in: nil).y > 0
            let transitionMadeSignificantProgress = percentageComplete > 0.1
            let shouldComplete = fingerIsMovingDownwards && transitionMadeSignificantProgress
            completeTransition(didCancel: !shouldComplete)

        default:
            break
        }
    }

    // MARK: - Private

    private func completeTransition(didCancel: Bool) {
        currentBackgroundAnimation?.isReversed = didCancel ? true : false

        guard let transitionContext = currentTransitionContext,
              let backgroundAnimation = currentBackgroundAnimation else { return }

        let completionDuration: Double = didCancel ? 0.46 : 0.36
        let completionDamping: CGFloat = didCancel ? 0.75 : 0.90

        let foregroundAnimation = UIViewPropertyAnimator(duration: completionDuration, dampingRatio: completionDamping) {
            self.currentTransitionImageView.transform = CGAffineTransform.identity

            if didCancel {
                if let fromFrame = self.fromReferenceImageViewFrame {
                    self.currentTransitionImageView.frame = fromFrame
                }
            } else {
                self.currentTransitionImageView.frame = self.toDelegate?.imageFrame() ?? self.toReferenceImageViewFrame ?? .zero
            }
        }

        foregroundAnimation.addCompletion { [weak self] _ in
            guard let self else { return }

            self.currentTransitionImageView.removeFromSuperview()
            self.currentTransitionImageView.image = nil

            self.toDelegate?.transitionDidEnd()
            self.fromDelegate.transitionDidEnd()

            if didCancel {
                transitionContext.cancelInteractiveTransition()
            } else {
                transitionContext.finishInteractiveTransition()
            }
            transitionContext.completeTransition(!didCancel)
            self.currentTransitionContext = nil
        }

        let durationFactor = CGFloat(foregroundAnimation.duration / backgroundAnimation.duration)
        backgroundAnimation.continueAnimation(withTimingParameters: nil, durationFactor: durationFactor)
        foregroundAnimation.startAnimation()
    }

    // ドラッグ量を0%〜100%の進捗に変換する (max=200px で100%)
    private func getPercentageComplete(forVerticalDrag verticalDrag: CGFloat) -> CGFloat {
        let maximumDelta = CGFloat(200)
        return CGFloat.scaleAndShift(value: verticalDrag, inRange: (min: CGFloat(0), max: maximumDelta))
    }

    // 進捗に応じたスナップショットの拡大縮小割合（最小 0.68）
    private func getTransitionImageScaleFor(percentageComplete: CGFloat) -> CGFloat {
        let minScale = CGFloat(0.68)
        return 1 - (1 - minScale) * percentageComplete
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PastaDetailInteractiveDismissTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.24
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        assertionFailure("インタラクティブ遷移では startInteractiveTransition が実行されるためここは通らない想定です。")
    }
}

// MARK: - UIViewControllerInteractiveTransitioning

extension PastaDetailInteractiveDismissTransition: UIViewControllerInteractiveTransitioning {

    func startInteractiveTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        currentTransitionContext = transitionContext

        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let fromImageFrame = fromDelegate.imageFrame(),
            let fromImage = fromDelegate.referenceImage(),
            let fromVC = transitionContext.viewController(forKey: .from) as? PastaDetailViewController
        else {
            return
        }

        fromVC.transitionController = self

        fromDelegate.transitionWillStart()
        toDelegate?.transitionWillStart()

        fromReferenceImageViewFrame = fromImageFrame
        toReferenceImageViewFrame = PastaDetailPopTransition.defaultOffscreenFrameForDismissal(
            transitionImageSize: fromImageFrame.size,
            screenHeight: fromView.bounds.height
        )

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(currentTransitionImageView)

        currentTransitionImageView.image = fromImage
        currentTransitionImageView.frame = fromImageFrame

        let animation = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            if let _ = self.toDelegate {
                fromView.alpha = 0
            } else {
                assertionFailure("toDelegateがnilです")
            }
        })

        currentBackgroundAnimation = animation
    }
}

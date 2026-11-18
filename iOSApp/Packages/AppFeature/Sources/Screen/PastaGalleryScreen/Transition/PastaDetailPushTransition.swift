import Foundation
import UIKit
import AppExtension

// MARK: - UINavigationController Push遷移時のカスタムトランジション
// 選択したサムネイル画像が、詳細画面に向かって浮き上がりながら拡大していく表現を実現する

final class PastaDetailPushTransition: NSObject {

    // MARK: - Property

    private let fromDelegate: PastaDetailTransitionAnimatorDelegate
    private let photoDetailVC: PastaDetailViewController

    // 画面遷移中に表示するスナップショット用UIImageView
    private let transitionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.accessibilityIgnoresInvertColors = true
        return iv
    }()

    // MARK: - Initializer

    init?(fromDelegate: Any, toPhotoDetailVC photoDetailVC: PastaDetailViewController) {
        guard let fromDelegate = fromDelegate as? PastaDetailTransitionAnimatorDelegate else {
            return nil
        }
        self.fromDelegate = fromDelegate
        self.photoDetailVC = photoDetailVC
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PastaDetailPushTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.24
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            return
        }

        // ContainerViewに遷移元・遷移先を追加する（遷移先は透明状態）
        let containerView = transitionContext.containerView
        toView.alpha = 0
        containerView.addSubview(fromView)
        containerView.addSubview(toView)

        // スナップショット用UIImageViewを配置する
        let transitionImage = fromDelegate.referenceImage()!
        transitionImageView.image = transitionImage
        transitionImageView.frame = fromDelegate.imageFrame()!
        containerView.addSubview(transitionImageView)

        // 画面遷移開始時の処理を呼び出す
        fromDelegate.transitionWillStart()
        photoDetailVC.transitionWillStart()

        // 画面遷移完了後に落ち着くべき矩形を算出する（詳細画面のUIImageView領域に対するAspectFit矩形）
        let toReferenceFrame = CGRect.makeRect(aspectRatio: transitionImage.size, insideRect: toView.bounds)

        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.93) {
            self.transitionImageView.frame = toReferenceFrame
            toView.alpha = 1
        }

        animator.addCompletion { _ in
            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.photoDetailVC.transitionDidEnd()
            self.fromDelegate.transitionDidEnd()
        }

        animator.startAnimation()
    }
}

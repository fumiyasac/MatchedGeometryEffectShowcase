import Foundation
import UIKit

// MARK: - カスタムトランジションを適用するUINavigationController

final class PastaGalleryNavigationController: UINavigationController {

    // 画面遷移に適用中のアニメーターを一時保持する
    private var currentAnimationTransition: (any UIViewControllerAnimatedTransitioning)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

// MARK: - UINavigationControllerDelegate

extension PastaGalleryNavigationController: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {

        var result: (any UIViewControllerAnimatedTransitioning)? = nil

        switch operation {
        case .push:
            if let photoDetailVC = toVC as? PastaDetailViewController {
                result = PastaDetailPushTransition(fromDelegate: fromVC, toPhotoDetailVC: photoDetailVC)
            }
        case .pop:
            if let photoDetailVC = fromVC as? PastaDetailViewController {
                if photoDetailVC.isInteractivelyDismissing {
                    result = PastaDetailInteractiveDismissTransition(fromDelegate: photoDetailVC, toDelegate: toVC)
                } else {
                    result = PastaDetailPopTransition(toDelegate: toVC, fromPhotoDetailVC: photoDetailVC)
                }
            }
        default:
            break
        }

        currentAnimationTransition = result
        return result
    }

    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning
    ) -> (any UIViewControllerInteractiveTransitioning)? {
        currentAnimationTransition as? (any UIViewControllerInteractiveTransitioning)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        currentAnimationTransition = nil
    }
}

import UIKit
import AppExtension

final class PopularScreenViewController: UIViewController {

    // MARK: - @IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("Popular")
        removeBackButtonText()
    }
}

// MARK: - StoryboardInstantiatable

extension PopularScreenViewController: StoryboardInstantiatable {

    static var storyboardName: String {
        return "PopularScreenViewController"
    }

    static var viewControllerIdentifier: String? {
        return nil
    }

    static var bundle: Bundle? {
        return Bundle.module
    }
}

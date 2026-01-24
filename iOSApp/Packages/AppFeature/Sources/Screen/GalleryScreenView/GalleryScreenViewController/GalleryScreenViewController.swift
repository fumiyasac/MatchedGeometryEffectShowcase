import UIKit
import AppExtension

final class GalleryScreenViewController: UIViewController {

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("Gallery")
        removeBackButtonText()
    }
}

// MARK: - StoryboardInstantiatable

extension GalleryScreenViewController: StoryboardInstantiatable {

    static var storyboardName: String {
        return "GalleryScreenViewController"
    }

    static var viewControllerIdentifier: String? {
        return nil
    }

    static var bundle: Bundle? {
        return Bundle.module
    }
}

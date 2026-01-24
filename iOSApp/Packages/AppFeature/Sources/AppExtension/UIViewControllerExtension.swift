import Foundation
import UIKit

extension UIViewController {

    public func setupNavigationBarTitle(_ title: String) {

        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.white

        guard let nav = self.navigationController else {
            return
        }
        nav.navigationBar.barTintColor = UIColor(code: "#869a42")
        nav.navigationBar.titleTextAttributes = attributes

        self.navigationItem.title = title
    }

    public func removeBackButtonText() {

        guard let nav = self.navigationController else {
            return
        }
        nav.navigationBar.tintColor = UIColor.white

        self.navigationItem.backButtonDisplayMode = .minimal
        self.navigationItem.backButtonTitle = self.navigationItem.title
    }
}

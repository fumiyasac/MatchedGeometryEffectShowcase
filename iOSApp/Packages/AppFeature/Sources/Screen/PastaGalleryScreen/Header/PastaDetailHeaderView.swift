import Foundation
import UIKit
import Common

final class PastaDetailHeaderView: CustomViewBase {

    // MARK: - Property

    override var nibBundle: Bundle {
        Bundle.module
    }

    var headerBackButtonTappedHandler: (() -> ())?

    @IBOutlet weak private var headerBackButton: UIButton!
    @IBOutlet weak private var headerTitleLabel: UILabel!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)
        setupPastaDetailHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPastaDetailHeaderView()
    }

    // MARK: - Function

    func setTitle(_ title: String) {
        headerTitleLabel.text = title
    }

    func changeAlpha(_ targetAlpha: CGFloat) {
        if targetAlpha > 1 {
            headerTitleLabel.alpha = 1
        } else if 0...1 ~= targetAlpha {
            headerTitleLabel.alpha = targetAlpha
        } else {
            headerTitleLabel.alpha = 0
        }
    }

    // MARK: - Private Function

    private func setupPastaDetailHeaderView() {
        backgroundColor = UIColor(red: 0.98, green: 0.84, blue: 0.63, alpha: 0.98)
        headerBackButton.addTarget(self, action: #selector(self.headerBackButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc private func headerBackButtonTapped(sender: UIButton) {
        headerBackButtonTappedHandler?()
    }
}

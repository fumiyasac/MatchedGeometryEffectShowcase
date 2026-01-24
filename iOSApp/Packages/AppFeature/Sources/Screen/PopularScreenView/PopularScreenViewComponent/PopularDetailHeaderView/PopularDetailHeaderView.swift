import UIKit
import Common

final class PopularDetailHeaderView: CustomViewBase {

    // MARK: - Property

    override var nibBundle: Bundle {
        Bundle.module
    }

    var headerBackButtonTappedHandler: (() -> ())?

    @IBOutlet weak private var headerBackgroundView: UIView!
    @IBOutlet weak private var headerWrappedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var headerTitle: UILabel!
    @IBOutlet weak private var headerBackButton: UIButton!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupPopularDetailHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupPopularDetailHeaderView()
    }

    // MARK: - Function

    func setTitle(_ title: String?) {
        headerTitle.text = title
    }

    func setHeaderBackgroundViewAlpha(_ alpha: CGFloat) {
        headerBackgroundView.alpha = alpha
    }

    func setHeaderNavigationTopConstraint(_ constant: CGFloat) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        let defaultHeaderMargin = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        if constant > 0 {
            headerWrappedViewTopConstraint.constant = defaultHeaderMargin + constant
        } else {
            headerWrappedViewTopConstraint.constant = defaultHeaderMargin
        }
        self.layoutIfNeeded()
    }

    // MARK: - Private Function

    private func setupPopularDetailHeaderView() {
        headerBackButton.addTarget(self, action:  #selector(self.headerBackButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc private func headerBackButtonTapped(sender: UIButton) {
        headerBackButtonTappedHandler?()
    }
}

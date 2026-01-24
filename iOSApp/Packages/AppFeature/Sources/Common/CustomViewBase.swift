import UIKit
import AppExtension

open class CustomViewBase: UIView {

    // MARK: - Property

    public weak var contentView: UIView!

    open var nibBundle: Bundle {
        Bundle(for: type(of: self))
    }

    // MARK: - Initializer

    public required override init(frame: CGRect) {
        super.init(frame: frame)
        initContentView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContentView()
    }

    // MARK: - Private Function

    private func initContentView() {

        let viewClass: AnyClass = type(of: self)

        contentView = nibBundle
            .loadNibNamed(String(describing: viewClass), owner: self, options: nil)?.first as? UIView
        contentView.autoresizingMask = autoresizingMask
        contentView.frame = bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        let bindings = ["view": contentView as Any]

        let contentViewConstraintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        let contentViewConstraintV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        addConstraints(contentViewConstraintH)
        addConstraints(contentViewConstraintV)
    }
}

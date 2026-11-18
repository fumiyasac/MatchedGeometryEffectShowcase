import UIKit
import Entity
import AppExtension

// MARK: - 詳細画面（Fluid Photo Gallery風）
// ・UIImageView（scaleAspectFit）を全画面に敷く
// ・UIPanGestureRecognizerによるインタラクティブな Pop を提供する
// ・画像下部にパスタのメタ情報を表示する（遷移アニメーションを妨げない位置）

final class PastaDetailViewController: UIViewController {

    // MARK: - @IBOutlet

    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Properties

    private let dismissPanGesture = UIPanGestureRecognizer()
    private var pasta: PastaEntity!

    // UIPanGestureRecognizerで発動したDismiss時のアニメーション発火状況
    private(set) var isInteractivelyDismissing: Bool = false

    // PhotoDetailInteractiveDismissTransition との連動用
    weak var transitionController: PastaDetailInteractiveDismissTransition? = nil

    // メタ情報オーバーレイ（遷移完了後にフェードインする）
    private lazy var infoCard: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alpha = 0
        return v
    }()

    private let categoryBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .bold)
        l.textColor = .white
        l.backgroundColor = UIColor(red: 0.98, green: 0.60, blue: 0.38, alpha: 1.0)
        l.textAlignment = .center
        l.layer.cornerRadius = 9
        l.clipsToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textColor = .white
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = UIColor.white.withAlphaComponent(0.9)
        l.numberOfLines = 3
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupImageView()
        setupInfoCard()
        setupDismissPanGesture()
    }

    private func setupNavigationBar() {
        title = pasta.title
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonDisplayMode = .minimal
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.05) {
            self.infoCard.alpha = 1
        }
    }

    // MARK: - Function

    func configure(with pasta: PastaEntity) {
        self.pasta = pasta
    }

    // MARK: - Private

    private func setupImageView() {
        imageView.image = UIImage(named: pasta.imageName, in: Bundle.module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.accessibilityIgnoresInvertColors = true
    }

    private func setupInfoCard() {
        view.addSubview(infoCard)
        infoCard.addSubview(categoryBadge)
        infoCard.addSubview(titleLabel)
        infoCard.addSubview(descriptionLabel)

        categoryBadge.text = "  \(pasta.category)  "
        titleLabel.text = pasta.title
        descriptionLabel.text = pasta.catchCopy

        NSLayoutConstraint.activate([
            infoCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            categoryBadge.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 14),
            categoryBadge.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 14),
            categoryBadge.heightAnchor.constraint(equalToConstant: 18),
            categoryBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),

            titleLabel.topAnchor.constraint(equalTo: categoryBadge.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -14),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 14),
            descriptionLabel.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -14),
            descriptionLabel.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -14),
        ])
    }

    private func setupDismissPanGesture() {
        view.addGestureRecognizer(dismissPanGesture)
        dismissPanGesture.addTarget(self, action: #selector(dismissPanGestureDidChange(_:)))
    }

    @objc private func dismissPanGestureDidChange(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            isInteractivelyDismissing = true
            self.navigationController?.popViewController(animated: true)
        case .cancelled, .failed, .ended:
            isInteractivelyDismissing = false
        default:
            break
        }
        transitionController?.didPanWith(gestureRecognizer: gesture)
    }
}

// MARK: - PastaDetailTransitionAnimatorDelegate

extension PastaDetailViewController: PastaDetailTransitionAnimatorDelegate {

    func transitionWillStart() {
        imageView.isHidden = true
        infoCard.alpha = 0
    }

    func transitionDidEnd() {
        imageView.isHidden = false
    }

    func referenceImage() -> UIImage? {
        imageView.image
    }

    func imageFrame() -> CGRect? {
        guard let image = imageView.image else { return nil }
        return CGRect.makeRect(aspectRatio: image.size, insideRect: imageView.bounds)
    }
}

// MARK: - StoryboardInstantiatable

extension PastaDetailViewController: StoryboardInstantiatable {

    static var storyboardName: String { "PastaGalleryViewController" }
    static var viewControllerIdentifier: String? { "PastaDetailViewController" }
    static var bundle: Bundle? { Bundle.module }
}

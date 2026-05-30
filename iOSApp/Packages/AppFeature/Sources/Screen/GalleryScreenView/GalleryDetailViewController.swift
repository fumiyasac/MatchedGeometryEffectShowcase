import UIKit
import Entity
import AppExtension

final class GalleryDetailViewController: UIViewController {

    // MARK: - @IBOutlet

    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: - Properties

    private var photo: GalleryPhotoEntity?

    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let headerView: GalleryDetailHeaderView = {
        let v = GalleryDetailHeaderView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let contentCard: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 28
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let categoryLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .systemGreen
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let catchCopyLabel: UILabel = {
        let l = UILabel()
        l.font = .italicSystemFont(ofSize: 15)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let bodyLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15)
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        buildLayout()
        if let photo { populateData(photo: photo) }
    }

    // MARK: - Function

    func configure(with photo: GalleryPhotoEntity) {
        self.photo = photo
        if isViewLoaded { populateData(photo: photo) }
    }

    // MARK: - Private

    private func buildLayout() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addSubview(heroImageView)
        scrollView.addSubview(contentCard)
        view.addSubview(headerView)

        let stack = UIStackView(arrangedSubviews: [categoryLabel, titleLabel, catchCopyLabel, bodyLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentCard.addSubview(stack)

        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 340),

            contentCard.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -36),
            contentCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCard.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentCard.widthAnchor.constraint(equalTo: view.widthAnchor),

            stack.topAnchor.constraint(equalTo: contentCard.topAnchor, constant: 28),
            stack.leadingAnchor.constraint(equalTo: contentCard.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentCard.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentCard.bottomAnchor, constant: -50),

            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
        ])

        headerView.headerBackButtonTappedHandler = { [weak self] in
            self?.dismiss(animated: true)
        }
        headerView.changeAlpha(0)
    }

    private func populateData(photo: GalleryPhotoEntity) {
        heroImageView.image = UIImage(named: photo.imageName, in: Bundle.module, compatibleWith: nil)
        categoryLabel.text = photo.category
        titleLabel.text = photo.title
        catchCopyLabel.text = photo.catchCopy
        bodyLabel.text = photo.descriptionText
        headerView.setTitle(photo.title)
    }
}

// MARK: - UIScrollViewDelegate

extension GalleryDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = min(max(scrollView.contentOffset.y / 220, 0), 1)
        headerView.changeAlpha(alpha)
    }
}

// MARK: - StoryboardInstantiatable

extension GalleryDetailViewController: StoryboardInstantiatable {

    static var storyboardName: String { "GalleryScreenViewController" }
    static var viewControllerIdentifier: String? { "GalleryDetailViewController" }
    static var bundle: Bundle? { Bundle.module }
}

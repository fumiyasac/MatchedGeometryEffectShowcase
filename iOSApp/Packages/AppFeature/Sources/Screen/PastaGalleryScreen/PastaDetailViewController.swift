import UIKit
import Entity
import AppExtension

final class PastaDetailViewController: UIViewController {

    // MARK: - @IBOutlet

    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: - Properties

    private var pasta: PastaEntity?

    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let headerView: PastaDetailHeaderView = {
        let v = PastaDetailHeaderView(frame: .zero)
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

    private let categoryBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .bold)
        l.textColor = .white
        l.backgroundColor = UIColor(red: 0.98, green: 0.60, blue: 0.38, alpha: 1.0)
        l.textAlignment = .center
        l.layer.cornerRadius = 10
        l.clipsToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 24, weight: .heavy)
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let catchCopyLabel: UILabel = {
        let l = UILabel()
        l.font = .italicSystemFont(ofSize: 15)
        l.textColor = .secondaryLabel
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
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
        if let pasta { populateData(pasta: pasta) }
    }

    // MARK: - Function

    func configure(with pasta: PastaEntity) {
        self.pasta = pasta
        if isViewLoaded { populateData(pasta: pasta) }
    }

    // MARK: - Private

    private func buildLayout() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addSubview(heroImageView)
        scrollView.addSubview(contentCard)
        view.addSubview(headerView)

        contentCard.addSubview(categoryBadge)
        contentCard.addSubview(titleLabel)
        contentCard.addSubview(catchCopyLabel)
        contentCard.addSubview(separator)
        contentCard.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 360),

            contentCard.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -40),
            contentCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCard.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentCard.widthAnchor.constraint(equalTo: view.widthAnchor),

            categoryBadge.topAnchor.constraint(equalTo: contentCard.topAnchor, constant: 28),
            categoryBadge.leadingAnchor.constraint(equalTo: contentCard.leadingAnchor, constant: 20),
            categoryBadge.heightAnchor.constraint(equalToConstant: 22),
            categoryBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: categoryBadge.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentCard.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentCard.trailingAnchor, constant: -20),

            catchCopyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            catchCopyLabel.leadingAnchor.constraint(equalTo: contentCard.leadingAnchor, constant: 20),
            catchCopyLabel.trailingAnchor.constraint(equalTo: contentCard.trailingAnchor, constant: -20),

            separator.topAnchor.constraint(equalTo: catchCopyLabel.bottomAnchor, constant: 16),
            separator.leadingAnchor.constraint(equalTo: contentCard.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: contentCard.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 0.5),

            bodyLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: contentCard.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: contentCard.trailingAnchor, constant: -20),
            bodyLabel.bottomAnchor.constraint(equalTo: contentCard.bottomAnchor, constant: -60),

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

    private func populateData(pasta: PastaEntity) {
        heroImageView.image = UIImage(named: pasta.imageName, in: Bundle.module, compatibleWith: nil)
        categoryBadge.text = "  \(pasta.category)  "
        titleLabel.text = pasta.title
        catchCopyLabel.text = pasta.catchCopy
        bodyLabel.text = pasta.descriptionText
        headerView.setTitle(pasta.title)
    }
}

// MARK: - UIScrollViewDelegate

extension PastaDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = min(max(scrollView.contentOffset.y / 220, 0), 1)
        headerView.changeAlpha(alpha)
    }
}

// MARK: - StoryboardInstantiatable

extension PastaDetailViewController: StoryboardInstantiatable {

    static var storyboardName: String { "PastaGalleryViewController" }
    static var viewControllerIdentifier: String? { "PastaDetailViewController" }
    static var bundle: Bundle? { Bundle.module }
}

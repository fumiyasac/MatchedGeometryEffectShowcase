import UIKit
import Entity
import AppExtension

final class PopularScreenDetailViewController: UIViewController {

    // MARK: - @IBOutlet

    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: - Properties

    private var article: PopularArticleEntity?

    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let headerView: PopularDetailHeaderView = {
        let v = PopularDetailHeaderView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let contentContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 24
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let categoryLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .systemOrange
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

    private let bodyLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15)
        l.textColor = .secondaryLabel
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let hashtagLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .systemBlue
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .systemBackground
        buildLayout()
        if let article { populateData(article: article) }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Function

    func configure(with article: PopularArticleEntity) {
        self.article = article
        if isViewLoaded { populateData(article: article) }
    }

    // MARK: - Private

    private func buildLayout() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addSubview(heroImageView)
        scrollView.addSubview(contentContainer)
        view.addSubview(headerView)

        let stack = UIStackView(arrangedSubviews: [categoryLabel, titleLabel, bodyLabel, hashtagLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(stack)

        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 320),

            contentContainer.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -32),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: view.widthAnchor),

            stack.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 28),
            stack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -40),

            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
        ])

        headerView.setTitle("")
        headerView.setHeaderBackgroundViewAlpha(0)
        headerView.headerBackButtonTappedHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    private func populateData(article: PopularArticleEntity) {
        heroImageView.image = UIImage(named: article.imageName, in: Bundle.module, compatibleWith: nil)
        categoryLabel.text = "\(article.articleMainCategory) › \(article.articleSubCategory)"
        titleLabel.text = article.articleTitle
        bodyLabel.text = article.articleText
        hashtagLabel.text = article.articleHashtags.joined(separator: "  ")
        headerView.setTitle(article.articleTitle)
    }
}

// MARK: - UIScrollViewDelegate

extension PopularScreenDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = min(max(scrollView.contentOffset.y / 200, 0), 1)
        headerView.setHeaderBackgroundViewAlpha(alpha)
        headerView.setHeaderNavigationTopConstraint(0)
    }
}

// MARK: - StoryboardInstantiatable

extension PopularScreenDetailViewController: StoryboardInstantiatable {

    static var storyboardName: String { "PopularScreenViewController" }
    static var viewControllerIdentifier: String? { "PopularScreenDetailViewController" }
    static var bundle: Bundle? { Bundle.module }
}

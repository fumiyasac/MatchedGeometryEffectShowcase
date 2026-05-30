import UIKit
import Entity
import AppExtension
import ViewStateProvider
import LocalStorage

final class PopularScreenViewController: UIViewController {

    // MARK: - @IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties

    private let stateProvider = PopularViewStateProvider()
    private let interactor = PopularInteractiveTransition()

    private enum Section: Int, CaseIterable {
        case hero, grid, products
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("Popular")
        removeBackButtonText()
        setupCollectionView()

        Task { await stateProvider.fetchAll() }
    }

    // MARK: - Private

    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(makeLayout(), animated: false)
        collectionView.register(PopularHeroCell.self, forCellWithReuseIdentifier: PopularHeroCell.reuseIdentifier)
        collectionView.register(PopularGridCell.self, forCellWithReuseIdentifier: PopularGridCell.reuseIdentifier)
        collectionView.register(PopularProductCell.self, forCellWithReuseIdentifier: PopularProductCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 32, right: 0)
    }

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch Section(rawValue: section) {
            case .hero:     return self?.makeHeroSection()
            case .grid:     return self?.makeGridSection()
            case .products: return self?.makeProductsSection()
            case nil:       return nil
            }
        }
    }

    private func makeHeroSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(220)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
        return section
    }

    private func makeGridSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 24, trailing: 12)
        return section
    }

    private func makeProductsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(200)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return section
    }

    private func navigateToDetail(article: PopularArticleEntity) {
        let detail = PopularScreenDetailViewController.instantiate()
        detail.configure(with: article)
        interactor.attach(to: detail)
        navigationController?.delegate = self
        navigationController?.pushViewController(detail, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension PopularScreenViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .hero:     return min(stateProvider.articleList.count, 3)
        case .grid:     return stateProvider.articleList.count
        case .products: return LocalMockDataProvider.products().count
        case nil:       return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .hero:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularHeroCell.reuseIdentifier, for: indexPath) as! PopularHeroCell
            cell.configure(with: stateProvider.articleList[indexPath.item])
            return cell
        case .grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularGridCell.reuseIdentifier, for: indexPath) as! PopularGridCell
            cell.configure(with: stateProvider.articleList[indexPath.item])
            return cell
        case .products:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularProductCell.reuseIdentifier, for: indexPath) as! PopularProductCell
            cell.configure(with: LocalMockDataProvider.products()[indexPath.item])
            return cell
        case nil:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PopularScreenViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch Section(rawValue: indexPath.section) {
        case .hero, .grid:
            navigateToDetail(article: stateProvider.articleList[indexPath.item])
        default:
            break
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension PopularScreenViewController: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        switch operation {
        case .push: return PopularTransitionAnimator(direction: .push)
        case .pop:  return PopularTransitionAnimator(direction: .pop)
        default:    return nil
        }
    }

    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning
    ) -> (any UIViewControllerInteractiveTransitioning)? {
        interactor.isInteracting ? interactor : nil
    }
}

// MARK: - StoryboardInstantiatable

extension PopularScreenViewController: StoryboardInstantiatable {

    static var storyboardName: String { "PopularScreenViewController" }
    static var viewControllerIdentifier: String? { nil }
    static var bundle: Bundle? { Bundle.module }
}

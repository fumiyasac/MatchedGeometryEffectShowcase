import UIKit
import AppExtension
import Entity
import ViewStateProvider

final class GalleryScreenViewController: UIViewController {

    // MARK: - @IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties

    private let stateProvider = GalleryStateProvider()
    private let presentAnimator = GalleryPresentAnimator(direction: .present)
    private let dismissAnimator = GalleryPresentAnimator(direction: .dismiss)
    private lazy var dismissInteractor = GalleryDismissInteractor(animator: dismissAnimator)

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("Gallery")
        removeBackButtonText()
        setupCollectionView()

        Task { await stateProvider.fetchAll() }
    }

    // MARK: - Private

    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(makeMosaicLayout(), animated: false)
        collectionView.register(GalleryMosaicCell.self, forCellWithReuseIdentifier: GalleryMosaicCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0)
    }

    private func makeMosaicLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { index, _ in
            let isEvenGroup = (index / 3) % 2 == 0
            return isEvenGroup
                ? Self.makeWideLeftSection()
                : Self.makeWideRightSection()
        }
    }

    private static func makeWideLeftSection() -> NSCollectionLayoutSection {
        let smallItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        )
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let smallGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1)),
            subitems: [smallItem, smallItem]
        )
        let largeItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1))
        )
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220)),
            subitems: [largeItem, smallGroup]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        return section
    }

    private static func makeWideRightSection() -> NSCollectionLayoutSection {
        let smallItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        )
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let smallGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1)),
            subitems: [smallItem, smallItem]
        )
        let largeItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1))
        )
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220)),
            subitems: [smallGroup, largeItem]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        return section
    }

    private func presentDetail(photo: GalleryPhotoEntity, from cell: GalleryMosaicCell) {
        let detailVC = GalleryDetailViewController.instantiate()
        detailVC.configure(with: photo)
        detailVC.transitioningDelegate = self
        detailVC.modalPresentationStyle = .fullScreen
        presentAnimator.sourceFrame = cell.convert(cell.bounds, to: nil)
        dismissAnimator.sourceFrame = cell.convert(cell.bounds, to: nil)
        dismissInteractor.attach(to: detailVC)
        present(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension GalleryScreenViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        max(Int(ceil(Double(stateProvider.photoList.count) / 3.0)), 1)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let start = section * 3
        let end = min(start + 3, stateProvider.photoList.count)
        return max(end - start, 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryMosaicCell.reuseIdentifier, for: indexPath) as! GalleryMosaicCell
        let index = indexPath.section * 3 + indexPath.item
        guard index < stateProvider.photoList.count else { return cell }
        cell.configure(with: stateProvider.photoList[index])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension GalleryScreenViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryMosaicCell else { return }
        let index = indexPath.section * 3 + indexPath.item
        guard index < stateProvider.photoList.count else { return }
        presentDetail(photo: stateProvider.photoList[index], from: cell)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension GalleryScreenViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        presentAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        dismissAnimator
    }

    func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        dismissInteractor.isInteracting ? dismissInteractor : nil
    }
}

// MARK: - StoryboardInstantiatable

extension GalleryScreenViewController: StoryboardInstantiatable {

    static var storyboardName: String { "GalleryScreenViewController" }
    static var viewControllerIdentifier: String? { nil }
    static var bundle: Bundle? { Bundle.module }
}

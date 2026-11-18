import UIKit
import AppExtension
import Entity
import ViewStateProvider

final class PastaGalleryViewController: UIViewController {

    // MARK: - @IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties

    private let stateProvider = PastaStateProvider()
    private let presentAnimator = PastaPresentAnimator(direction: .present)
    private let dismissAnimator = PastaPresentAnimator(direction: .dismiss)
    private lazy var dismissInteractor = PastaDismissInteractor(animator: dismissAnimator)

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("Pasta Gallery")
        removeBackButtonText()
        setupCollectionView()
        bindStateProvider()
        Task { await stateProvider.fetchAll() }
    }

    // MARK: - Private

    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(makeMosaicLayout(), animated: false)
        collectionView.register(PastaMosaicCell.self, forCellWithReuseIdentifier: PastaMosaicCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0)
    }

    private func bindStateProvider() {
        // MEMO: Observation Frameworkによるデータバインディング
        withObservationTracking {
            _ = stateProvider.pastaList
        } onChange: { [weak self] in
            Task { @MainActor in
                self?.collectionView.reloadData()
                self?.bindStateProvider()
            }
        }
    }

    // MARK: - Mosaic Layout (FluidPhotoGallery風)

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
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(240)),
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
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(240)),
            subitems: [smallGroup, largeItem]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        return section
    }

    private func presentDetail(pasta: PastaEntity, from cell: PastaMosaicCell) {
        let detailVC = PastaDetailViewController.instantiate()
        detailVC.configure(with: pasta)
        detailVC.transitioningDelegate = self
        detailVC.modalPresentationStyle = .fullScreen
        presentAnimator.sourceFrame = cell.convert(cell.bounds, to: nil)
        presentAnimator.sourceImage = cell.imageView.image
        dismissAnimator.sourceFrame = cell.convert(cell.bounds, to: nil)
        dismissInteractor.attach(to: detailVC)
        present(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension PastaGalleryViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        max(Int(ceil(Double(stateProvider.pastaList.count) / 3.0)), 1)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let start = section * 3
        let end = min(start + 3, stateProvider.pastaList.count)
        return max(end - start, 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PastaMosaicCell.reuseIdentifier, for: indexPath) as! PastaMosaicCell
        let index = indexPath.section * 3 + indexPath.item
        guard index < stateProvider.pastaList.count else { return cell }
        cell.configure(with: stateProvider.pastaList[index])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PastaGalleryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? PastaMosaicCell else { return }
        let index = indexPath.section * 3 + indexPath.item
        guard index < stateProvider.pastaList.count else { return }
        presentDetail(pasta: stateProvider.pastaList[index], from: cell)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PastaGalleryViewController: UIViewControllerTransitioningDelegate {

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

extension PastaGalleryViewController: StoryboardInstantiatable {

    static var storyboardName: String { "PastaGalleryViewController" }
    static var viewControllerIdentifier: String? { nil }
    static var bundle: Bundle? { Bundle.module }
}

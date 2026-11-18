import UIKit
import AppExtension
import Entity
import ViewStateProvider

final class PastaGalleryViewController: UIViewController {

    // MARK: - @IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties

    private let stateProvider = PastaStateProvider()

    // 画面遷移時に押下されたIndexPathを一時保存する
    private var selectedIndexPath: IndexPath? = nil

    // MARK: - Layout Constants

    private let columnCount: CGFloat = 3
    private let cellSpacing: CGFloat = 1.0

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCollectionView()
        bindStateProvider()
        Task { await stateProvider.fetchAll() }
    }

    // MARK: - Private

    private func setupNavigationBar() {
        // 他の SwiftUI 画面 (.navigationTitle + .large) と同じ見た目を得るため
        // システムデフォルトの透過背景 + Large Title を使う
        title = "Pasta Gallery"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backButtonDisplayMode = .minimal
    }

    private func setupCollectionView() {
        collectionView.register(PastaMosaicCell.self, forCellWithReuseIdentifier: PastaMosaicCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        // MEMO: NavigationBar / TabBar 下まで content を流し、SwiftUI の ScrollView と同じ見た目を得るための設定
        collectionView.contentInsetAdjustmentBehavior = .automatic

        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.minimumInteritemSpacing = cellSpacing
            flow.minimumLineSpacing = cellSpacing
            flow.sectionInset = .zero
            // MEMO: self-sizing セルを無効化する（本画面は delegate で固定サイズを返すため）
            flow.estimatedItemSize = .zero
        }
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
}

// MARK: - UICollectionViewDataSource

extension PastaGalleryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stateProvider.pastaList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PastaMosaicCell.reuseIdentifier, for: indexPath) as! PastaMosaicCell
        guard indexPath.item < stateProvider.pastaList.count else { return cell }
        cell.configure(with: stateProvider.pastaList[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PastaGalleryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < stateProvider.pastaList.count else { return }
        let pasta = stateProvider.pastaList[indexPath.item]

        selectedIndexPath = indexPath

        let detailVC = PastaDetailViewController.instantiate()
        detailVC.configure(with: pasta)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PastaGalleryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 3列グリッド。横幅から隙間を差し引いて均等割する
        let totalSpacing = cellSpacing * (columnCount - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        let side = floor(availableWidth / columnCount)
        return CGSize(width: side, height: side)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
}

// MARK: - PastaDetailTransitionAnimatorDelegate

extension PastaGalleryViewController: PastaDetailTransitionAnimatorDelegate {

    func transitionWillStart() {
        if let selectedIndexPath, let cell = collectionView.cellForItem(at: selectedIndexPath) as? PastaMosaicCell {
            cell.isHidden = true
        }
    }

    func transitionDidEnd() {
        if let selectedIndexPath, let cell = collectionView.cellForItem(at: selectedIndexPath) as? PastaMosaicCell {
            cell.isHidden = false
        }
    }

    func referenceImage() -> UIImage? {
        guard let selectedIndexPath,
              let cell = collectionView.cellForItem(at: selectedIndexPath) as? PastaMosaicCell else {
            return nil
        }
        return cell.thumbnailImageView.image
    }

    func imageFrame() -> CGRect? {
        guard let selectedIndexPath,
              let cell = collectionView.cellForItem(at: selectedIndexPath) as? PastaMosaicCell else {
            return nil
        }
        return collectionView.convert(cell.frame, to: self.view)
    }
}

// MARK: - StoryboardInstantiatable

extension PastaGalleryViewController: StoryboardInstantiatable {

    static var storyboardName: String { "PastaGalleryViewController" }
    static var viewControllerIdentifier: String? { nil }
    static var bundle: Bundle? { Bundle.module }
}

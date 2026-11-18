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
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.bounces = false
        collectionView.register(PastaMosaicCell.self, forCellWithReuseIdentifier: PastaMosaicCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground

        // Storyboard側で MultipleScrollDirectionLayout を適用している前提で delegate を紐付ける
        if let multipleScrollDirectionLayout = collectionView.collectionViewLayout as? MultipleScrollDirectionLayout {
            multipleScrollDirectionLayout.delegate = self
            multipleScrollDirectionLayout.cellSpacing = 1.0
            // MEMO: automaticSize だと UICollectionView が cell に self-sizing を要求し、
            // 固定サイズを返す本カスタムレイアウトと再計算の無限ループを起こしてクラッシュするため明示的に無効化する
            multipleScrollDirectionLayout.estimatedItemSize = .zero
        }
    }

    private func bindStateProvider() {
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
// MEMO: 横方向のセル数は numberOfItemsInSection, 縦方向のセル数は numberOfSections で定義する
// 24枚のパスタ画像を 4列 × 6行 で配置する

extension PastaGalleryViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        stateProvider.pastaList.isEmpty ? 0 : 6
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stateProvider.pastaList.isEmpty ? 0 : 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PastaMosaicCell.reuseIdentifier, for: indexPath) as! PastaMosaicCell
        let fixedIndex = indexPath.section * 4 + indexPath.row
        guard fixedIndex < stateProvider.pastaList.count else { return cell }
        cell.configure(with: stateProvider.pastaList[fixedIndex])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PastaGalleryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fixedIndex = indexPath.section * 4 + indexPath.row
        guard fixedIndex < stateProvider.pastaList.count else { return }
        let pasta = stateProvider.pastaList[fixedIndex]

        selectedIndexPath = indexPath

        let detailVC = PastaDetailViewController.instantiate()
        detailVC.configure(with: pasta)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PastaGalleryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        PastaMosaicCell.cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
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

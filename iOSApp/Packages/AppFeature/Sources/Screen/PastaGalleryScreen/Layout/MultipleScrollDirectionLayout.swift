import Foundation
import UIKit

// MARK: - Fluid Photo Gallery 風 縦横両方向スクロールレイアウト
// MEMO: UICollectionViewFlowLayoutを継承し、以下のルールでレイアウトを実行する
// (1) 横方向のセル数は `numberOfItemsInSection` で定義する
// (2) 縦方向のセル数は `numberOfSections` で定義する
// (3) セルサイズは `UICollectionViewDelegateFlowLayout.sizeForItemAt` で返した値を利用する
// (4) `cellSpacing` でセル間の隙間を設定可能（デフォルト1pt）

final class MultipleScrollDirectionLayout: UICollectionViewFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout

    weak var delegate: UICollectionViewDelegateFlowLayout?

    // MARK: - Properties

    // MEMO: セル同士の間に設ける隙間（pt）
    var cellSpacing: CGFloat = 1.0

    private var layoutInfo: [IndexPath : UICollectionViewLayoutAttributes] = [:]
    private var maxRowsWidth: CGFloat = 0
    private var maxColumnHeight: CGFloat = 0

    // MARK: - Override (Computed Property)

    override var collectionViewContentSize: CGSize {
        CGSize(width: maxRowsWidth, height: maxColumnHeight)
    }

    // MARK: - Override (Function)

    override func prepare() {
        super.prepare()

        guard let targetCollectionView = self.collectionView else {
            fatalError("対象のUICollectionViewが配置されていません。")
        }
        guard let _ = targetCollectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            fatalError("対象のUICollectionViewDelegateFlowLayoutが定義されていません。")
        }

        calculateMaxRowsWidth()
        calculateMaxColumnHeight()
        calculateCellLayoutInfo()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in layoutInfo.values where rect.intersects(attributes.frame) {
            visibleLayoutAttributes.append(attributes)
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        layoutInfo[indexPath]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }

    // MARK: - Private

    // セクション毎の横方向セル要素群を基に全体の幅の最大値を算出する（隙間込み）
    private func calculateMaxRowsWidth() {
        guard let targetCollectionView = self.collectionView, let targetDelegate = self.delegate else { return }

        var maxRowWidth: CGFloat = 0
        for section in 0..<targetCollectionView.numberOfSections {
            let itemCount = targetCollectionView.numberOfItems(inSection: section)
            var rowWidth: CGFloat = 0
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                if let itemSize = targetDelegate.collectionView?(targetCollectionView, layout: self, sizeForItemAt: indexPath) {
                    rowWidth += itemSize.width
                }
            }
            // セル間の隙間を加算する
            if itemCount > 1 {
                rowWidth += cellSpacing * CGFloat(itemCount - 1)
            }
            if rowWidth > maxRowWidth { maxRowWidth = rowWidth }
        }
        maxRowsWidth = maxRowWidth
    }

    // セクション毎の縦方向セル要素群を基に全体の高さの最大値を算出する（隙間込み）
    private func calculateMaxColumnHeight() {
        guard let targetCollectionView = self.collectionView, let targetDelegate = self.delegate else { return }

        var totalHeight: CGFloat = 0
        let sectionCount = targetCollectionView.numberOfSections
        for section in 0..<sectionCount {
            var maxRowHeight: CGFloat = 0
            for item in 0..<targetCollectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                if let itemSize = targetDelegate.collectionView?(targetCollectionView, layout: self, sizeForItemAt: indexPath) {
                    if itemSize.height > maxRowHeight { maxRowHeight = itemSize.height }
                }
            }
            totalHeight += maxRowHeight
        }
        // セクション間の隙間を加算する
        if sectionCount > 1 {
            totalHeight += cellSpacing * CGFloat(sectionCount - 1)
        }
        maxColumnHeight = totalHeight
    }

    // 各セルのレイアウト属性を算出する（隙間込み）
    private func calculateCellLayoutInfo() {
        guard let targetCollectionView = self.collectionView, let targetDelegate = self.delegate else { return }

        var cellLayoutInfo: [IndexPath : UICollectionViewLayoutAttributes] = [:]
        var originY: CGFloat = 0

        for section in 0..<targetCollectionView.numberOfSections {
            var rowMaxHeight: CGFloat = 0
            var originX: CGFloat = 0
            for item in 0..<targetCollectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                if let itemSize = targetDelegate.collectionView?(targetCollectionView, layout: self, sizeForItemAt: indexPath) {
                    itemAttributes.frame = CGRect(x: originX, y: originY, width: itemSize.width, height: itemSize.height)
                    cellLayoutInfo[indexPath] = itemAttributes
                    originX += itemSize.width + cellSpacing
                    if itemSize.height > rowMaxHeight { rowMaxHeight = itemSize.height }
                }
            }
            originY += rowMaxHeight + cellSpacing
        }
        layoutInfo = cellLayoutInfo
    }
}

import UIKit
import Entity

// MARK: - FluidPhotoGallery風のシンプルなサムネイルセル（角丸なし・画像のみ）

final class PastaMosaicCell: UICollectionViewCell {

    static let reuseIdentifier = "PastaMosaicCell"
    static let cellSize: CGSize = CGSize(width: 200.0, height: 200.0)

    private(set) lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.accessibilityIgnoresInvertColors = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        isHidden = false
    }

    private func setup() {
        contentView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func configure(with pasta: PastaEntity) {
        thumbnailImageView.image = UIImage(named: pasta.imageName, in: Bundle.module, compatibleWith: nil)
    }
}

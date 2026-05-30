import UIKit
import Entity

final class PopularProductCell: UICollectionViewCell {

    static let reuseIdentifier = "PopularProductCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .label
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .monospacedDigitSystemFont(ofSize: 13, weight: .bold)
        l.textColor = .systemOrange
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let saleBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 10, weight: .bold)
        l.textColor = .white
        l.backgroundColor = .systemRed
        l.textAlignment = .center
        l.layer.cornerRadius = 4
        l.clipsToBounds = true
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.separator.cgColor

        [imageView, nameLabel, priceLabel, saleBadge].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            saleBadge.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            saleBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            saleBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 36),
            saleBadge.heightAnchor.constraint(equalToConstant: 18),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }

    func configure(with product: ProductEntity) {
        nameLabel.text = product.productName
        imageView.image = UIImage(named: product.imageName, in: Bundle.module, compatibleWith: nil)

        if product.isSale {
            priceLabel.text = "¥\(product.discountedPrice)"
            saleBadge.text = "  \(product.percentSale)%OFF  "
            saleBadge.isHidden = false
        } else {
            priceLabel.text = "¥\(product.regularPrice)"
            saleBadge.isHidden = true
        }
    }
}

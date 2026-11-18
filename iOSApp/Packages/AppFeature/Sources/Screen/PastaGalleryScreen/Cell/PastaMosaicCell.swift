import UIKit
import Entity

final class PastaMosaicCell: UICollectionViewCell {

    static let reuseIdentifier = "PastaMosaicCell"

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .white
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let categoryLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 10, weight: .bold)
        l.textColor = .white
        l.backgroundColor = UIColor(red: 0.98, green: 0.60, blue: 0.38, alpha: 0.9)
        l.textAlignment = .center
        l.layer.cornerRadius = 8
        l.clipsToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        categoryLabel.text = nil
    }

    private func setup() {
        layer.cornerRadius = 10
        clipsToBounds = true

        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.65).cgColor]
        gradientLayer.locations = [0.45, 1.0]
        contentView.layer.addSublayer(gradientLayer)

        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            categoryLabel.heightAnchor.constraint(equalToConstant: 16),
            categoryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    func configure(with pasta: PastaEntity) {
        titleLabel.text = pasta.title
        categoryLabel.text = "  \(pasta.category)  "
        imageView.image = UIImage(named: pasta.imageName, in: Bundle.module, compatibleWith: nil)
    }
}

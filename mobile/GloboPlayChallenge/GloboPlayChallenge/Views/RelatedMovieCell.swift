import UIKit
import Kingfisher

final class RelatedMovieCell: UICollectionViewCell {

    // MARK: - Identificador
    static let identifier = "RelatedMovieCell"
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // MARK: - Inicialização
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuração da View
    private func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Reuso
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        titleLabel.text = nil
    }

    // MARK: - Configuração pública
    func configure(with movie: Movie) {
        titleLabel.text = movie.title ?? movie.name ?? "Sem título"

        if let path = movie.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w300\(path)") {
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "film"),
                options: [.transition(.fade(0.3))]
            )
        } else {
            imageView.image = UIImage(systemName: "film")
            imageView.contentMode = .scaleAspectFit
        }
    }

    // MARK: - Interação visual (animação ao toque)
    private func setupInteraction() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(_:)))
        tap.minimumPressDuration = 0
        addGestureRecognizer(tap)
    }

    @objc private func handlePress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            animateScale(to: 0.95)
        case .ended, .cancelled:
            animateScale(to: 1.0)
        default:
            break
        }
    }

    private func animateScale(to value: CGFloat) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.transform = CGAffineTransform(scaleX: value, y: value)
        }
    }
}

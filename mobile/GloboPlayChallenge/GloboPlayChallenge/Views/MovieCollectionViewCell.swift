import UIKit
import Kingfisher

final class MovieCollectionViewCell: UICollectionViewCell {

    // MARK: - Identificador
    static let identifier = "MovieCollectionViewCell"

    // MARK: - UI Components
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1) // fundo neutro durante carregamento
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Inicialização
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuração
    private func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(posterImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Reuso
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }

    // MARK: - Configuração pública
    public func configure(with posterPath: String?) {
        guard let path = posterPath,
              let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
            posterImageView.image = UIImage(systemName: "film")
            posterImageView.contentMode = .scaleAspectFit
            return
        }

        posterImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "film"),
            options: [.transition(.fade(0.3))]
        )
    }
}

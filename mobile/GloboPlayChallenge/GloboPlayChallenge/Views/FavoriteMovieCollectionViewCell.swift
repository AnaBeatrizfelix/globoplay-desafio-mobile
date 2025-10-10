import UIKit
import Kingfisher

protocol FavoriteMovieCollectionViewCellDelegate: AnyObject {
    func didSelectFavorite(in cell: FavoriteMovieCollectionViewCell)
}

final class FavoriteMovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identificador
    static let identifier = "FavoriteMovieCollectionViewCell"
    
    // MARK: - UI Components
    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let iconImage = UIImage(systemName: "heart.fill")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        button.setImage(iconImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Delegate
    weak var delegate: FavoriteMovieCollectionViewCellDelegate?
    
    // MARK: - Init
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(favoriteButton)
        
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePosterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 180),
            
            movieTitleLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 8),
            movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 6),
            favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: 25),
            favoriteButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    // MARK: - Configuração pública
    func setupView(_ movie: Movie) {
        movieTitleLabel.text = movie.title ?? movie.name ?? "Sem título"
        
        if let posterPath = movie.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            moviePosterImageView.kf.setImage(with: url,
                                             placeholder: UIImage(systemName: "film"),
                                             options: [.transition(.fade(0.3))])
        } else {
            moviePosterImageView.image = UIImage(systemName: "film")
        }
    }
    
    // MARK: - Ação
    @objc private func didTapFavoriteButton() {
        delegate?.didSelectFavorite(in: self)
    }
    
    // MARK: - Toque no botão
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let buttonPoint = favoriteButton.convert(point, from: self)
        if favoriteButton.bounds.contains(buttonPoint) {
            return favoriteButton
        }
        return super.hitTest(point, with: event)
    }
    
    // MARK: - Reuso
    override func prepareForReuse() {
        super.prepareForReuse()
        moviePosterImageView.kf.cancelDownloadTask()
        moviePosterImageView.image = nil
        movieTitleLabel.text = nil
    }
}

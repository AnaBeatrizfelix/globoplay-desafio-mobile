import UIKit


protocol FavoriteMovieCollectionViewCellDelegate: AnyObject {
    func didSelectFavorite(in cell: FavoriteMovieCollectionViewCell)
}

class FavoriteMovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoriteMovieCollectionViewCell"
    
    // MARK: - UI Components
    private lazy var moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12.0
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let iconImage = UIImage(systemName: "heart.fill")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        button.setImage(iconImage, for: .normal)
        
        button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: FavoriteMovieCollectionViewCellDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupConstraints() {
        addSubview(moviePosterImageView)
        addSubview(movieTitleLabel)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: topAnchor),
            moviePosterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviePosterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 180),
            
            movieTitleLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 8),
            movieTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 6),
            favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: 25),
            favoriteButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    // MARK: - Configure
    func setupView(_ movie: Movie) {
        movieTitleLabel.text = movie.title ?? movie.name ?? "Sem título"
        
        if let posterPath = movie.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            moviePosterImageView.kf.setImage(with: url)
        } else {
            moviePosterImageView.image = UIImage(systemName: "film")
        }
    }
    
    // MARK: - Action
    @objc private func didTapFavoriteButton(_ sender: UIButton) {
        delegate?.didSelectFavorite(in: self)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let buttonPoint = favoriteButton.convert(point, from: self)
        
        if favoriteButton.bounds.contains(buttonPoint) {
            return favoriteButton
        }
        return super.hitTest(point, with: event)
    }
}

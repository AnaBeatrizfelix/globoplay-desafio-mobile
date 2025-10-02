import UIKit

class MovieDetailsViewController: UIViewController {
    
    private var movie: Movie
    
  
    private let posterImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    // Sinopse
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.85)
        label.numberOfLines = 0
        return label
    }()
    
    // retirei imegeEdegeInstes, por conta da versão IOS 15 que recomenda usar UIButton.Configuration
    
    private let assistaButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Assista"
        config.image = UIImage(systemName: "play.fill")
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .medium
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var myListButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.title = "Minha lista"
        config.image = UIImage(systemName: "plus")
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.lineBreakMode = .byClipping
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    // SegmentControl
    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["ASSISTA TAMBÉM", "DETALHES"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        return sc
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        configureWithMovie()
    }
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(assistaButton)
        view.addSubview(myListButton)
        view.addSubview(segmentControl)
        view.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 160),
            posterImageView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            assistaButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            assistaButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            assistaButton.widthAnchor.constraint(equalToConstant: 150),
            assistaButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            myListButton.topAnchor.constraint(equalTo: assistaButton.topAnchor),
            myListButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            myListButton.widthAnchor.constraint(equalTo: assistaButton.widthAnchor),
            myListButton.heightAnchor.constraint(equalTo: assistaButton.heightAnchor),
            
            
            
            segmentControl.topAnchor.constraint(equalTo: assistaButton.bottomAnchor, constant: 20),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            detailsLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureWithMovie() {
        if let posterPath = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.sd_setImage(with: url)
        }
        titleLabel.text = movie.title
        subtitleLabel.text = "Filme / Série / Novela"
        overviewLabel.text = movie.overview ?? "Sem descrição disponível."
        
        detailsLabel.text = """
        Título Original: \(String(describing: movie.originalTitle ?? movie.title))
        Idioma: \(movie.originalLanguage ?? "N/A")
        Lançamento: \(movie.releaseDate ?? "N/A")
        """
    }
}

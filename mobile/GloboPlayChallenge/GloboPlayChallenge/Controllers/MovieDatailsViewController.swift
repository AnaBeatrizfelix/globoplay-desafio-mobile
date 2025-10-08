import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var movie: Movie
    private var movieDetails: MovieDetails?
    private var relatedMovies: [Movie] = []
    
    // MARK: - ScrollView
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI Components

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle(" Voltar", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    private lazy var  posterImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.85)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var assistaButton: UIButton = {
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
        button.addTarget(self, action: #selector(didTapMyListButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["ASSISTA TAMBÉM", "DETALHES"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var relatedMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 16, right: 12)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.register(RelatedMovieCell.self, forCellWithReuseIdentifier: RelatedMovieCell.identifier)
        return collection
    }()
    
    // MARK: - Inicializador
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        updateMyListButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyListButton), name: .favoritesUpdated, object: nil)
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentChanged()
        
        relatedMoviesCollectionView.delegate = self
        relatedMoviesCollectionView.dataSource = self
        navigationItem.hidesBackButton = true
        view.backgroundColor = .black
        
        // MARK: - Busca os detalhes corretos (tv ou movie)
        Task {
            do {
                let type = movie.mediaType == "Cinema" ? "movie" : "tv"
                
                if type == "tv" {
                    self.movieDetails = try await MovieService().getTVDetails(id: movie.id)
                    self.relatedMovies = try await MovieService().getSimilarContent(id: movie.id, type: "tv")
                } else {
                    self.movieDetails = try await MovieService().getMovieDetails(id: movie.id)
                    self.relatedMovies = try await MovieService().getSimilarContent(id: movie.id, type: "movie")
                }

                
                DispatchQueue.main.async {
                    self.configureUI()
                    self.relatedMoviesCollectionView.reloadData()
                }
            } catch {
                print("Erro ao carregar detalhes:", error)
            }
        }
    }
    
    // MARK: - Botões
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapMyListButton() {
        MovieManager.shared.add(movie)
        updateMyListButton()
    }
    
    @objc private func updateMyListButton() {
        var config = UIButton.Configuration.bordered()
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.cornerStyle = .medium
        
        if MovieManager.shared.isFavorite(movie) {
            config.title = "Adicionado"
            config.image = UIImage(systemName: "checkmark")
            config.baseForegroundColor = .lightGray
        } else {
            config.title = "Minha lista"
            config.image = UIImage(systemName: "plus")
            config.baseForegroundColor = .white
        }
        
        myListButton.configuration = config
    }
    
    // MARK: - Layout
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backButton, posterImageView, titleLabel, subtitleLabel, overviewLabel, assistaButton, myListButton, segmentControl, detailsLabel, relatedMoviesCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            posterImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 160),
            posterImageView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            assistaButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            assistaButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            assistaButton.widthAnchor.constraint(equalToConstant: 150),
            assistaButton.heightAnchor.constraint(equalToConstant: 44),
            
            myListButton.topAnchor.constraint(equalTo: assistaButton.topAnchor),
            myListButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            myListButton.widthAnchor.constraint(equalTo: assistaButton.widthAnchor),
            myListButton.heightAnchor.constraint(equalTo: assistaButton.heightAnchor),
            
            segmentControl.topAnchor.constraint(equalTo: assistaButton.bottomAnchor, constant: 20),
            segmentControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            detailsLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            relatedMoviesCollectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            relatedMoviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            relatedMoviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            relatedMoviesCollectionView.heightAnchor.constraint(equalToConstant: 500),
            relatedMoviesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Troca de aba
    @objc private func segmentChanged() {
        let isAssistaTab = segmentControl.selectedSegmentIndex == 0
        relatedMoviesCollectionView.isHidden = !isAssistaTab
        detailsLabel.isHidden = isAssistaTab
    }
    
    // MARK: - Config de UI
    private func configureUI() {
        if let pathPath = movie.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(pathPath)") {
            posterImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = movie.title ?? movie.name ?? "Sem título"
        subtitleLabel.text =  movie.mediaType
        overviewLabel.text = movie.overview ?? movieDetails?.descricao ?? "Sem descrição disponível."
        
        if let details = movieDetails {
            detailsLabel.text = """
            Ficha Técnicare
            Título Original: \(details.titleOriginal ?? "")
            Gênero: \(details.genero ?? "")
            País: \(details.pais ?? "")
            Lançamento: \(details.dataLancamento ?? "")
            Idioma: \(details.idioma ?? "")
            Descrição: \(details.descricao ?? "")
            """
        }
    }
}

// MARK: - UICollectionView
extension MovieDetailsViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        relatedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedMovieCell.identifier, for: indexPath) as? RelatedMovieCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: relatedMovies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 3
        return CGSize(width: width, height: width * 1.5)
    }
}


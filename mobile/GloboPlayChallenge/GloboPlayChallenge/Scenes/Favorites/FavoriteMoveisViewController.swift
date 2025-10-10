import UIKit

// MARK: - Display Protocol
protocol FavoriteMoviesDisplayLogic: AnyObject {
    func displayFavorites(_ viewModel: FavoriteMoviesModels.FetchFavorites.ViewModel)
}

final class FavoriteMoviesViewController: UIViewController,
                                          FavoriteMoviesDisplayLogic,
                                          UICollectionViewDelegateFlowLayout,
                                          UICollectionViewDataSource,
                                          FavoriteMovieCollectionViewCellDelegate {

    // VIP
    var interactor: FavoriteMoviesBusinessLogic?

    // Estado da View
    private var viewModel: FavoriteMoviesModels.FetchFavorites.ViewModel?
    private var movies: [Movie] = []

    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        layout.minimumLineSpacing = 47
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(
            FavoriteMovieCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoriteMovieCollectionViewCell.identifier
        )
        collectionView.register(
            FavoriteCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FavoriteCollectionReusableView.identifier
        )

        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        setupVIP()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupVIP() {
        let interactor = FavoriteMoviesInteractor()
        let presenter = FavoriteMoviesPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
        self.interactor = interactor
    }

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupConstraints()
        setupNotifications()
        interactor?.fetchFavorites(.init())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.fetchFavorites(.init())
    }

    // MARK: - Layout
    private func setupConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Observadores
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFavorites),
            name: .favoritesUpdated,
            object: nil
        )
    }

    @objc private func updateFavorites() {
        interactor?.fetchFavorites(.init())
    }

    // MARK: - Display
    func displayFavorites(_ viewModel: FavoriteMoviesModels.FetchFavorites.ViewModel) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
            self.movies = viewModel.movies
            self.collectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteMovieCollectionViewCell.identifier,
            for: indexPath
        ) as? FavoriteMovieCollectionViewCell else {
            fatalError("Erro ao criar FavoriteMovieCollectionViewCell")
        }

        let currentMovie = movies[indexPath.item]
        cell.setupView(currentMovie)
        cell.delegate = self
        return cell
    }

    // MARK: - Header
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FavoriteCollectionReusableView.identifier,
                for: indexPath
            ) as? FavoriteCollectionReusableView else {
                fatalError("Erro ao criar header da collection view")
            }

            headerView.setupTitle(viewModel?.title ?? "Minha Lista")
            return headerView
        }

        return UICollectionReusableView()
    }

    // MARK: - Layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 10
        let totalSpacing: CGFloat = (columns - 1) * spacing + 40
        let itemWidth = (collectionView.frame.width - totalSpacing) / columns
        let itemHeight = itemWidth * 1.75
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }

    // MARK: - Delegate da célula de favorito
    func didSelectFavorite(in cell: FavoriteMovieCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let selectedMovie = movies[indexPath.item]
        interactor?.toggleFavorite(selectedMovie)
    }
}

#Preview {
    FavoriteMoviesViewController()
}

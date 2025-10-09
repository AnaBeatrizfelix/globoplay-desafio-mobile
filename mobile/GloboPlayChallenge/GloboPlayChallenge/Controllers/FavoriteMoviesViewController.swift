import UIKit

class FavoriteMoviesViewController: UIViewController {
    
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
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .clear
        
        setupConstraints()
        setupNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
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
        collectionView.reloadData()
    }
}

// MARK: - DataSource
extension FavoriteMoviesViewController: UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoritesManager.shared.favoriteMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteMovieCollectionViewCell.identifier,
            for: indexPath
        ) as? FavoriteMovieCollectionViewCell else {
            fatalError("Erro ao criar FavoriteMovieCollectionViewCell")
        }

        let currentMovie = FavoritesManager.shared.favoriteMovies[indexPath.item]

        cell.setupView(currentMovie)
        cell.delegate = self
        
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FavoriteCollectionReusableView.identifier,
                for: indexPath
            ) as? FavoriteCollectionReusableView else {
                fatalError("Erro ao criar header da collection view")
            }
            
            headerView.setupTitle("Minha Lista")
            return headerView
        }
        
        return UICollectionReusableView()
    }
}

// MARK: - Layout 
extension FavoriteMoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 10
        let totalSpacing: CGFloat = (columns - 1) * spacing + 40
        let itemWidth = (collectionView.frame.width - totalSpacing) / columns
        let itemHeight = itemWidth * 1.75
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

// MARK: - Delegate da célula de favorito
extension FavoriteMoviesViewController: FavoriteMovieCollectionViewCellDelegate {
    
    func didSelectFavorite(in cell: FavoriteMovieCollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let selectedMovie = FavoritesManager.shared.favoriteMovies[indexPath.item]
        
        FavoritesManager.shared.toggle(selectedMovie)
        collectionView.reloadData()
    }
}

#Preview {
    FavoriteMoviesViewController()
}

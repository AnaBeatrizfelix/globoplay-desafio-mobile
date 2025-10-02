class MovieManager {
    
    // MARK: - Singleton
    static let shared = MovieManager()
    private init() { }
    
    // MARK: - Attributes
    private(set) var favoritesMovies: [Movie] = []
    
    // MARK: - Methods
    func add(_ movie: Movie) {
        if favoritesMovies.contains(where: { $0.id == movie.id }) {
            remove(movie)
        } else {
            favoritesMovies.append(movie)
        }
    }
    
    func remove(_ movie: Movie) {
        if let index = favoritesMovies.firstIndex(where: { $0.id == movie.id }) {
            favoritesMovies.remove(at: index)
        }
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        return favoritesMovies.contains(where: { $0.id == movie.id })
    }
}

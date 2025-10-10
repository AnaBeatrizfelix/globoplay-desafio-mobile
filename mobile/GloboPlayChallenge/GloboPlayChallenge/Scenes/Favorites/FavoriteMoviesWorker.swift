import Foundation

final class FavoriteMoviesWorker {
    func fetchFavorites() -> [Movie] {
        return FavoritesManager.shared.favoriteMovies
    }
}

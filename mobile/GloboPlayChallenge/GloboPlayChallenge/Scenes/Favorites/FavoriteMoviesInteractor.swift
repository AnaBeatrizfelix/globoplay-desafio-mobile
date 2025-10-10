import Foundation

protocol FavoriteMoviesBusinessLogic {
    func fetchFavorites(_ request: FavoriteMoviesModels.FetchFavorites.Request)
    func toggleFavorite(_ movie: Movie)
}

final class FavoriteMoviesInteractor: FavoriteMoviesBusinessLogic {
    var presenter: FavoriteMoviesPresentationLogic?
    var worker = FavoriteMoviesWorker()

    func fetchFavorites(_ request: FavoriteMoviesModels.FetchFavorites.Request) {
        let favorites = worker.fetchFavorites()
        let response = FavoriteMoviesModels.FetchFavorites.Response(movies: favorites)
        presenter?.presentFavorites(response)
    }

    func toggleFavorite(_ movie: Movie) {
        FavoritesManager.shared.toggle(movie)
        // Atualiza lista depois de alterar
        let updated = worker.fetchFavorites()
        let response = FavoriteMoviesModels.FetchFavorites.Response(movies: updated)
        presenter?.presentFavorites(response)
    }
}

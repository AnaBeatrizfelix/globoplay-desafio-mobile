import Foundation

protocol FavoriteMoviesPresentationLogic: AnyObject {
    func presentFavorites(_ response: FavoriteMoviesModels.FetchFavorites.Response)
}

final class FavoriteMoviesPresenter: FavoriteMoviesPresentationLogic {
    weak var viewController: FavoriteMoviesDisplayLogic?

    func presentFavorites(_ response: FavoriteMoviesModels.FetchFavorites.Response) {
        let viewModel = FavoriteMoviesModels.FetchFavorites.ViewModel(
            movies: response.movies,
            title: "Minha Lista"
        )

        DispatchQueue.main.async {
            self.viewController?.displayFavorites(viewModel)
        }
    }
}

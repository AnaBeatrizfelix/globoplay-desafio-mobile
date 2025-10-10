import Foundation

enum FavoriteMoviesModels {
    enum FetchFavorites {
        struct Request { }
        struct Response {
            let movies: [Movie]
        }
        struct ViewModel {
            let movies: [Movie]
            let title: String
        }
    }
}

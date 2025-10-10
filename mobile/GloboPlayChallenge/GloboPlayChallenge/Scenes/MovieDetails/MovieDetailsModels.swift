import Foundation

enum MovieDetailsModels {
    
    enum Fetch {
        struct Request {
            let movie: Movie
        }
        struct Response {
            let movie: Movie
            let details: MovieDetails?
            let related: [Movie]
        }
        struct ViewModel {
            let title: String
            let subtitle: String
            let overview: String
            let posterURL: URL?
            let detailsText: String
            let related: [Movie]
        }
    }
}

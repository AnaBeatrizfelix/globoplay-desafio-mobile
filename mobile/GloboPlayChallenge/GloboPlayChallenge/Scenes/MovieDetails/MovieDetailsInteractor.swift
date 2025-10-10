import Foundation

protocol MovieDetailsBusinessLogic {
    func fetchMovieDetails(_ request: MovieDetailsModels.Fetch.Request)
}

final class MovieDetailsInteractor: MovieDetailsBusinessLogic {
    var presenter: MovieDetailsPresentationLogic?
    var worker = MovieDetailsWorker()

    func fetchMovieDetails(_ request: MovieDetailsModels.Fetch.Request) {
        Task {
            do {
                let type = request.movie.mediaType == "Cinema" ? "movie" : "tv"
                let details = try await worker.fetchDetails(for: request.movie.id, type: type)
                let related = try await worker.fetchRelated(for: request.movie.id, type: type)

                let response = MovieDetailsModels.Fetch.Response(
                    movie: request.movie,
                    details: details,
                    related: related
                )
                presenter?.presentMovieDetails(response)
            } catch {
                print("Erro ao buscar detalhes:", error)
            }
        }
    }
}

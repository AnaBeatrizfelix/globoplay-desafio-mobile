import Foundation

final class MovieDetailsWorker {
    private let service = MovieService()

    func fetchDetails(for id: Int, type: String) async throws -> MovieDetails {
        if type == "tv" {
            return try await service.getTVDetails(id: id)
        } else {
            return try await service.getMovieDetails(id: id)
        }
    }

    func fetchRelated(for id: Int, type: String) async throws -> [Movie] {
        return try await service.getSimilarContent(id: id, type: type)
    }
}

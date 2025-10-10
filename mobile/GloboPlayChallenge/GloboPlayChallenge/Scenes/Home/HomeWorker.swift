import Foundation

// MARK: - Worker (Acesso à API)
final class HomeWorker {

    private let service = MovieService()

    func fetchNovelas() async throws -> [Movie] {
        try await service.getPopularNovelas()
    }

    func fetchSeries() async throws -> [Movie] {
        try await service.getPopularSeries()
    }

    func fetchCinema() async throws -> [Movie] {
        try await service.getPopularMovies()
    }
}

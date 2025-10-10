import Foundation

// MARK: - Enum de erros
enum MovieServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}

// MARK: - Serviço principal (Worker)
final class MovieService {

    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "6ab31bc2eb05690d1679fef51b5b25b5"
    private let language = "pt-BR"

    // MARK: - Métodos Públicos

    func getPopularMovies() async throws -> [Movie] {
        try await fetchMovies(endpoint: "/movie/popular")
    }

    func getPopularSeries() async throws -> [Movie] {
        try await fetchMovies(endpoint: "/tv/on_the_air")
    }

    func getPopularNovelas() async throws -> [Movie] {
        try await fetchMovies(endpoint: "/discover/tv", extraParams: "&with_genres=10766")
    }

    func getMovieDetails(id: Int) async throws -> MovieDetails {
        try await fetchMovieDetails(endpoint: "/movie/\(id)")
    }

    func getTVDetails(id: Int) async throws -> MovieDetails {
        try await fetchMovieDetails(endpoint: "/tv/\(id)")
    }

    func getSimilarContent(id: Int, type: String) async throws -> [Movie] {
        try await fetchMovies(endpoint: "/\(type)/\(id)/similar")
    }

    // MARK: - Funções auxiliares

    private func fetchMovies(endpoint: String, extraParams: String = "") async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)&language=\(language)\(extraParams)") else {
            throw MovieServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieServiceError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decoded.results
        } catch {
            print("Erro ao decodificar lista:", error)
            throw MovieServiceError.decodingFailed
        }
    }

    private func fetchMovieDetails(endpoint: String) async throws -> MovieDetails {
        guard let url = URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)&language=\(language)") else {
            throw MovieServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieServiceError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(MovieDetailsResponse.self, from: data)
            return MovieDetails(
                id: decoded.id, titleOriginal: decoded.original_title ?? decoded.original_name ?? decoded.title ?? decoded.name ?? "Sem título",
                genero: decoded.genres.first?.name ?? "Não informado",
                pais: decoded.origin_country?.first ?? "Desconhecido",
                dataLancamento: decoded.release_date ?? decoded.first_air_date ?? "Desconhecida", 
                idioma: "Português",
                descricao: "Informações adicionais disponíveis em breve."
            )
        } catch {
            print("Erro ao decodificar detalhes:", error)
            throw MovieServiceError.decodingFailed
        }
    }
}

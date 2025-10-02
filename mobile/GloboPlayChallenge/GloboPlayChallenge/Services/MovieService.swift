import Foundation

enum MovieServiceError: Error {
    case invalidURL
    case decodingFailed
    case invalidResponse
}


struct MovieService {
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "6ab31bc2eb05690d1679fef51b5b25b5"
    
    // Filmes Populares
        func getPopularMovies() async throws -> [Movie] {
            let urlString = "\(baseURL)/discover/tv?api_key=\(apiKey)&language=pt-BR&page=1&with_genres=10766"
            return try await fetchMovies(from: urlString)
        }
        
        // Séries Populares
        func getPopularSeries() async throws -> [Movie] {
            let urlString = "\(baseURL)/tv/top_rated?api_key=\(apiKey)&language=pt-BR&page=1"
            return try await fetchMovies(from: urlString)
        }
        
        // Descobrir conteúdo (pode ser usado para novelas, minisséries, etc.)
        func getDiscoverTV() async throws -> [Movie] {
            let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=pt-BR&page=1"
            return try await fetchMovies(from: urlString)
        }
        
        // Função genérica para evitar repetição
        private func fetchMovies(from urlString: String) async throws -> [Movie] {
            guard let url = URL(string: urlString) else {
                throw MovieServiceError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MovieServiceError.invalidResponse
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                return movieResponse.results
            } catch {
                print("Erro de decode:", error)
                throw MovieServiceError.decodingFailed
            }
        }
    }

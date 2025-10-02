import Foundation

enum MovieServiceError: Error {
    case invalidURL
    case decodingFailed
    case invalidResponse
}

struct MovieService {
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "6ab31bc2eb05690d1679fef51b5b25b5"
    
    func getMovies() async throws -> [Movie] {
    let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=pt-BR&page=1"
        guard let url = URL(string: urlString) else {
            throw MovieServiceError.invalidURL
        }
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MovieServiceError.invalidResponse
        }
        do {
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return movieResponse.results
        } catch (let error) {
            print(error)
            throw MovieServiceError.decodingFailed
            
            
        }
    }
}

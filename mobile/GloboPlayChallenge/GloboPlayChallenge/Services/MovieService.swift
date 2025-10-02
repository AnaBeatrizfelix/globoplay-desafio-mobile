import Foundation

enum MovieServiceError: Error {
    case invalidURL
    case decodingFailed
    case invalidResponse
}
enum FilterType {
    case cinema
    case series
    case novelas
    
    var path: String {
        switch self {
        case .cinema:
            return "/movie/popular"
        case .series:
            return "/tv/popular"
        case .novelas:
            return "/tv/popular"
        }
    }
}

struct MovieService {
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "6ab31bc2eb05690d1679fef51b5b25b5"
    
    func fetch(by filter: FilterType) async throws -> [Movie] {
        let urlString = "\(baseURL)\(filter.path)?api_key=\(apiKey)&language=pt-BR&page=1"
        
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
            if filter == .novelas {
                return movieResponse.results.filter {  $0.genreIds.contains(10766) }
            }
            return movieResponse.results
        } catch {
            throw MovieServiceError.decodingFailed
            
            
        }
    }
}

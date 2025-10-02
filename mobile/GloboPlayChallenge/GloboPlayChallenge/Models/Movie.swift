import Foundation
import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let mediaType: String?
    let originalLanguage: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let releaseDate: String?
    let genreIds: [Int]
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case id, overview, title
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }
}

// MARK: - Extensões úteis
extension Movie {
    /// URL completa do poster
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    /// Título pronto para exibição
    var displayTitle: String {
        originalTitle ?? "Título indisponível"
    }
    
    /// Data formatada
    var displayReleaseDate: String {
        releaseDate ?? "N/A"
    }
}

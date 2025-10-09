import Foundation

struct Movie: Codable, Equatable {
    var id: Int
    var mediaType: String?
    var originalLanguage: String?
    var originalTitle: String?
    var posterPath: String?
    var overview: String?
    var releaseDate: String?
    var genreIds: [Int]
    var title: String?
    var name: String?
    var originalName: String?
    var firstAirDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, overview, title, name, originalName
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case firstAirDate = "first_air_date"
        
    }
}

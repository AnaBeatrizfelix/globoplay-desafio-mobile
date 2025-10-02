import Foundation

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_language: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_content: Int?
    let release_date: String?
    let vote_average: Double?
    let genre_ids: [Int]
}

enum CodingKeys: String, CodingKey {
    case id
    case mediaType = "media_type"
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case posterPath = "poster_path"
    case overview
    case voteCount = "vote_count"
    case releaseDate = "release_date"
    case voteAverage = "vote_average"
    case genreIds = "genre_ids"
}

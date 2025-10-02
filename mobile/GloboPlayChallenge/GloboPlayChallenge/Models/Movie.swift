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
    
    private(set) var isSelected: Bool? = false
    
    //MARK: - Class Methods
    
    mutating func changeSelectionStatus() {
        isSelected = !(isSelected ?? false)      }
    
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

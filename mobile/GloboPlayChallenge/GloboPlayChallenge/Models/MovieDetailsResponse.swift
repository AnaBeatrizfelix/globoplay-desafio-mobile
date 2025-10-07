//
//  MovieDetailsResponse.swift
//  GloboPlayChallenge
//
//  Created by ana on 06/10/25.
//

import Foundation

struct MovieDetailsResponse: Decodable {
    var id: Int
    var title: String?
    var name: String?
    var original_title: String?
    var original_name: String?
    var genres: [Genre]
    var origin_country: [String]?
    var release_date: String?
    var first_air_date: String?
    var overview: String?
}

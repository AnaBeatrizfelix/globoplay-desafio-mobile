//
//  MovieDetailsResponse.swift
//  GloboPlayChallenge
//
//  Created by ana on 06/10/25.
//

import Foundation

struct MovieDetailsResponse: Decodable {
    let id: Int
    let title: String?
    let name: String?
    let original_title: String?
    let original_name: String?
    let genres: [Genre]
    let origin_country: [String]?
    let release_date: String?
    let first_air_date: String?
    let overview: String?
}

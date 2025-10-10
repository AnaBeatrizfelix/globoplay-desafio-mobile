//
//  MovieDetails.swift
//  GloboPlayChallenge
//
//  Created by ana on 03/10/25.
//

import Foundation

struct MovieDetails: Decodable {
    var id: Int?
    var titleOriginal: String?
    var genero: String?
    var pais: String?
    var dataLancamento: String?
    var idioma: String?
    var descricao: String?
}

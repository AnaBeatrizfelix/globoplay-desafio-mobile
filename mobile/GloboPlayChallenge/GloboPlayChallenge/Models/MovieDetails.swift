//
//  MovieDetails.swift
//  GloboPlayChallenge
//
//  Created by ana on 03/10/25.
//

import Foundation

struct MovieDetails: Decodable {
    let id: Int?
    let titleOriginal: String?
    let genero: String?
    let pais: String?
    let dataLancamento: String?
    let idioma: String?
    let descricao: String
}

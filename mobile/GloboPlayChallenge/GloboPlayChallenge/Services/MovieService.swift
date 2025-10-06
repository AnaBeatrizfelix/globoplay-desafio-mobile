//
//  MovieService.swift
//  GloboPlayChallenge
//
//  Created by ana on 03/10/25.
//

import Foundation

// MARK: - Enum de erros
enum MovieServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}

// MARK: - Serviço principal
struct MovieService {
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "6ab31bc2eb05690d1679fef51b5b25b5"
    
    // MARK: - Listagens principais
    
    func getPopularNovelas() async throws -> [Movie] {
        let urlString = "\(baseURL)/discover/tv?api_key=\(apiKey)&language=pt-BR&page=1&with_genres=10766"
        return try await fetchMovies(from: urlString)
    }
    
    func getPopularSeries() async throws -> [Movie] {
        let urlString = "\(baseURL)/tv/top_rated?api_key=\(apiKey)&language=pt-BR&page=1"
        return try await fetchMovies(from: urlString)
    }
    
    func getPopularMovies() async throws -> [Movie] {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=pt-BR&page=1"
        return try await fetchMovies(from: urlString)
    }
    
    // MARK: - Detalhes (filmes e séries)
    
    func getMovieDetails(id: Int) async throws -> MovieDetails {
        let urlString = "\(baseURL)/movie/\(id)?api_key=\(apiKey)&language=pt-BR"
        return try await fetchMovieDetails(from: urlString)
    }
    
    func getTVDetails(id: Int) async throws -> MovieDetails {
        let urlString = "\(baseURL)/tv/\(id)?api_key=\(apiKey)&language=pt-BR"
        return try await fetchMovieDetails(from: urlString)
    }
    
    // MARK: - Funções auxiliares
    
    private func fetchMovies(from urlString: String) async throws -> [Movie] {
        guard let url = URL(string: urlString) else {
            throw MovieServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MovieServiceError.invalidResponse
        }
        
        do {
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return movieResponse.results
        } catch {
            print("Erro ao decodificar lista:", error)
            throw MovieServiceError.decodingFailed
        }
    }
    
    private func fetchMovieDetails(from urlString: String) async throws -> MovieDetails {
        guard let url = URL(string: urlString) else {
            throw MovieServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MovieServiceError.invalidResponse
        }
        
        do {
            let detailsResponse = try JSONDecoder().decode(MovieDetailsResponse.self, from: data)
            
            let details = MovieDetails(
                id: detailsResponse.id,
                titleOriginal: detailsResponse.original_title
                    ?? detailsResponse.original_name
                    ?? detailsResponse.title
                    ?? detailsResponse.name
                    ?? "Título desconhecido",
                genero: detailsResponse.genres.first?.name ?? "Não informado",
                pais: detailsResponse.origin_country?.first ?? "Desconhecido",
                dataLancamento: detailsResponse.release_date
                    ?? detailsResponse.first_air_date
                    ?? "Desconhecida",
                idioma: "Português",
                descricao: "Informações adicionais disponíveis em breve."
            )
            
            return details
        } catch {
            print("Erro ao decodificar detalhes:", error)
            throw MovieServiceError.decodingFailed
        }
    }
}
// MARK: - Extensão “Assista também”
extension MovieService {
    
    /// Busca filmes relacionados (“Assista também”)
    func getSimilarMovies(id: Int) async throws -> [Movie] {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)/similar?api_key=\(apiKey)&language=pt-BR&page=1"
        return try await fetchMovies(from: urlString)
    }
    
    /// Busca séries relacionadas (“Assista também”)
    func getSimilarTVShows(id: Int) async throws -> [Movie] {
        let urlString = "https://api.themoviedb.org/3/tv/\(id)/similar?api_key=\(apiKey)&language=pt-BR&page=1"
        return try await fetchMovies(from: urlString)
    }
}

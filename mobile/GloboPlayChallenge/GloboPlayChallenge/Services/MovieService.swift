//
//  MovieService.swift
//  GloboPlayChallenge
//
//  Created by Ana on 03/10/25.
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
    
    // MARK: - Busca de conteúdo
    
    func getPopularMovies() async throws -> [Movie] {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=pt-BR&page=1"
        return try await fetchMovies(from: urlString)
    }

    func getPopularSeries() async throws -> [Movie] {
        let urlString = "\(baseURL)/tv/on_the_air?api_key=\(apiKey)&language=pt-BR&page=1"
        return try await fetchMovies(from: urlString)
    }

    func getPopularNovelas() async throws -> [Movie] {
        let urlString = "\(baseURL)/discover/tv?api_key=\(apiKey)&language=pt-BR&page=1&with_genres=10766"
        return try await fetchMovies(from: urlString)
    }

    // MARK: - Detalhes de conteúdo
    
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
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decoded.results
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
            let decoded = try JSONDecoder().decode(MovieDetailsResponse.self, from: data)
            return MovieDetails(
                id: decoded.id,
                titleOriginal: decoded.original_title ?? decoded.original_name ?? decoded.title ?? decoded.name ?? "Sem título",
                genero: decoded.genres.first?.name ?? "Não informado",
                pais: decoded.origin_country?.first ?? "Desconhecido",
                dataLancamento: decoded.release_date ?? decoded.first_air_date ?? "Desconhecida",
                idioma: "Português",
                descricao: "Informações adicionais disponíveis em breve."
            )
        } catch {
            print("Erro ao decodificar detalhes:", error)
            throw MovieServiceError.decodingFailed
        }
    }
}

// MARK: - Extensão (Assista também)
extension MovieService {
    func getSimilarContent(id: Int, type: String) async throws -> [Movie] {
        let urlString = "https://api.themoviedb.org/3/\(type)/\(id)/similar?api_key=\(apiKey)&language=pt-BR&page=1"
        print("Requesting URL:", urlString)
        return try await fetchMovies(from: urlString)
    }
}


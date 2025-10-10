

import Foundation

/// Gerencia os filmes favoritos usando UserDefaults
final class FavoritesManager {
    
    // MARK: - Singleton
    static let shared = FavoritesManager()
    private init() {
        loadFavorites()
    }
    
    // MARK: - Propriedades
    private let defaults = UserDefaults.standard
    private let key = "favoriteMovies"
    private(set) var favoriteMovies: [Movie] = []
    
    // MARK: - Métodos principais
    
    /// Adiciona o filme aos favoritos (se ainda não existir)
    func add(_ movie: Movie) {
        guard !isFavorite(movie) else { return }
        favoriteMovies.append(movie)
        saveFavorites()
        notifyChange()
    }
    
    /// Remove o filme dos favoritos
    func remove(_ movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
        saveFavorites()
        notifyChange()
    }
    
    /// Alterna entre favoritar e desfavoritar (toggle)
    func toggle(_ movie: Movie) {
        isFavorite(movie) ? remove(movie) : add(movie)
    }
    
    /// Verifica se o filme já está nos favoritos
    func isFavorite(_ movie: Movie) -> Bool {
        favoriteMovies.contains { $0.id == movie.id }
    }
    
    // MARK: - Persistência
    
    /// Salva os favoritos no UserDefaults
    private func saveFavorites() {
        guard let data = try? JSONEncoder().encode(favoriteMovies) else { return }
        defaults.set(data, forKey: key)
    }
    
    /// Carrega os favoritos salvos do UserDefaults
    private func loadFavorites() {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Movie].self, from: data)
        else { return }
        favoriteMovies = decoded
    }
    
    // MARK: - Notificação global
    
    /// Envia notificação para atualizar telas (UI)
    private func notifyChange() {
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }
}

// MARK: - Extensão para a notificação de atualização
extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}

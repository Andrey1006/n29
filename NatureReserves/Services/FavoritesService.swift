import Foundation

final class FavoritesService {
    static let shared = FavoritesService()

    private let defaults = UserDefaults.standard
    private let favoriteIdsKey = "favorites.reserveIds"

    private init() {}

    func favoriteIds() -> [String] {
        defaults.stringArray(forKey: favoriteIdsKey) ?? []
    }

    func isFavorite(reserveId: String) -> Bool {
        favoriteIds().contains(reserveId)
    }

    func addFavorite(reserveId: String) {
        var ids = favoriteIds()
        if !ids.contains(reserveId) {
            ids.append(reserveId)
            defaults.set(ids, forKey: favoriteIdsKey)
        }
    }

    func removeFavorite(reserveId: String) {
        var ids = favoriteIds()
        ids.removeAll { $0 == reserveId }
        defaults.set(ids, forKey: favoriteIdsKey)
    }

    func toggleFavorite(reserveId: String) {
        if isFavorite(reserveId: reserveId) {
            removeFavorite(reserveId: reserveId)
        } else {
            addFavorite(reserveId: reserveId)
        }
    }

    func favoritesCount() -> Int {
        favoriteIds().count
    }

    func clearAll() {
        defaults.set([String](), forKey: favoriteIdsKey)
    }
}

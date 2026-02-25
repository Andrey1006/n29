import Foundation

final class UserProfileService {
    static let shared = UserProfileService()

    private let defaults = UserDefaults.standard
    private let displayNameKey = "userProfile.displayName"
    private let avatarIdKey = "userProfile.avatarId"

    private init() {}

    func getDisplayName() -> String {
        defaults.string(forKey: displayNameKey) ?? "Username"
    }

    func getAvatarId() -> Int {
        let value = defaults.integer(forKey: avatarIdKey)
        return value >= 1 && value <= 4 ? value : 1
    }

    func save(displayName: String?, avatarId: Int?) {
        if let name = displayName {
            defaults.set(name.isEmpty ? "Username" : name, forKey: displayNameKey)
        }
        if let id = avatarId, id >= 1, id <= 4 {
            defaults.set(id, forKey: avatarIdKey)
        }
    }

    func saveDisplayName(_ name: String) {
        defaults.set(name.isEmpty ? "Username" : name, forKey: displayNameKey)
    }

    func saveAvatarId(_ id: Int) {
        if id >= 1, id <= 4 {
            defaults.set(id, forKey: avatarIdKey)
        }
    }

    func clear() {
        defaults.removeObject(forKey: displayNameKey)
        defaults.removeObject(forKey: avatarIdKey)
    }
}

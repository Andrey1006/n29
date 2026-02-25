import Foundation

final class SettingsService {
    static let shared = SettingsService()

    private let defaults = UserDefaults.standard
    private let notificationsKey = "settings.notifications"
    private let pushKey = "settings.push"
    private let vibrationKey = "settings.vibration"
    private let soundEffectsKey = "settings.soundEffects"

    private init() {}

    var notificationsOn: Bool {
        get { defaults.object(forKey: notificationsKey) as? Bool ?? true }
        set { defaults.set(newValue, forKey: notificationsKey) }
    }

    var pushOn: Bool {
        get { defaults.object(forKey: pushKey) as? Bool ?? false }
        set { defaults.set(newValue, forKey: pushKey) }
    }

    var vibrationOn: Bool {
        get { defaults.object(forKey: vibrationKey) as? Bool ?? false }
        set { defaults.set(newValue, forKey: vibrationKey) }
    }

    var soundEffectsOn: Bool {
        get { defaults.object(forKey: soundEffectsKey) as? Bool ?? true }
        set { defaults.set(newValue, forKey: soundEffectsKey) }
    }
}

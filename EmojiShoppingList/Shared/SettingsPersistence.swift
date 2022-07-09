import Foundation

enum SettingsKey: String {
    case listName = "settings.list.name"
    case colorTheme = "settings.color.theme"
}

struct SettingsPersistence {
    var saveSetting: (_ value: Any?, _ key: SettingsKey) -> Void
    var setting: (_ key: SettingsKey) -> Any?
}

extension SettingsPersistence {
    static let `default` = SettingsPersistence(
        saveSetting: { value, key in
            UserDefaults.standard.set(value, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        }, setting: { key in
            UserDefaults.standard.value(forKey: key.rawValue)
        }
    )
}

import Foundation
@testable import Shopping_List

extension SettingsPersistence {
    static let mock: (_ mock: MockSettingsPerstence?) -> SettingsPersistence = { mock in
        guard let mock = mock else {
            return SettingsPersistence(
                saveSetting: { _, _ in fatalError("Mock not implemented") },
                setting: { _ in fatalError("Mock not implemented") }
            )
        }
        
        return SettingsPersistence(
            saveSetting: mock.saveSetting,
            setting: mock.setting
        )
    }
}

final class MockSettingsPerstence {
    
    var invokedSaveSetting = false
    var invokedSaveSettingCount = 0
    var invokedSaveSettingParameters: (value: Any?, key: SettingsKey)?
    var invokedSaveSettingParametersList = [(value: Any?, key: SettingsKey)]()
    var stubbedSaveSettingResult: Void! = ()
    
    func saveSetting(_ value: Any?, _ key: SettingsKey) -> Void {
        invokedSaveSetting = true
        invokedSaveSettingCount += 1
        invokedSaveSettingParameters = (value, key)
        invokedSaveSettingParametersList.append((value, key))
        return stubbedSaveSettingResult
    }
    
    var invokedSetting = false
    var invokedSettingCount = 0
    var invokedSettingParameters: (key: SettingsKey, Void)?
    var invokedSettingParametersList = [(key: SettingsKey, Void)]()
    var stubbedSettingResult: Any!
    
    func setting(_ key: SettingsKey) -> Any? {
        invokedSetting = true
        invokedSettingCount += 1
        invokedSettingParameters = (key, ())
        invokedSettingParametersList.append((key, ()))
        return stubbedSettingResult
    }
}

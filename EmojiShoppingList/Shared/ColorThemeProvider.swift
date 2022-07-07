import SwiftUI

enum ColorTheme: Int, CaseIterable {
    case primary
    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
    case gray
    
    var color: Color {
        switch self {
        case .primary: return .primary
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .mint: return .mint
        case .teal: return .teal
        case .cyan: return .cyan
        case .blue: return .blue
        case .indigo: return .indigo
        case .purple: return .purple
        case .pink: return .pink
        case .brown: return .brown
        case .gray: return .gray
        }
    }
    
    var description: String {
        switch self {
        case .primary: return "Panda Black & White"
        case .red: return "Tomato Red"
        case .orange: return "Orange Orange"
        case .yellow: return "Banana Yellow"
        case .green: return "Apple Green"
        case .mint: return "Liberty Mint"
        case .teal: return "Ice Blue"
        case .cyan: return "Ocean Blue"
        case .blue: return "Blueberry Blue"
        case .indigo: return "Eggplant Indigo"
        case .purple: return "Sweet Potato Purple"
        case .pink: return "Grape Pink"
        case .brown: return "Chocolate Brown"
        case .gray: return "Wolf Gray"
        }
    }
    
    var emoji: String {
        switch self {
        case .primary: return "🐼"
        case .red: return "🍅"
        case .orange: return "🍊"
        case .yellow: return "🍌"
        case .green: return "🍏"
        case .mint: return "🗽"
        case .teal: return "🧊"
        case .cyan: return "🌊"
        case .blue: return "🫐"
        case .indigo: return "🍆"
        case .purple: return "🍠"
        case .pink: return "🍇"
        case .brown: return "🍩"
        case .gray: return "🐺"
        }
    }
}

struct ColorThemeProvider {
    var color: () -> Color
}

extension ColorThemeProvider {
    static let `default`: ColorThemeProvider = ColorThemeProvider(
        color: {
            guard
                let currentTheme = SettingsPersistence.default.setting(.colorTheme) as? Int,
                let theme = ColorTheme(rawValue: currentTheme)
            else {
                let defaultTheme: ColorTheme = .blue
                let index = ColorTheme.allCases.firstIndex(of: defaultTheme)!
                SettingsPersistence.default.saveSetting(index, .colorTheme)
                return defaultTheme.color
            }
            
            return theme.color
        }
    )
}

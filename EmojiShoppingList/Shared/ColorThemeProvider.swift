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
        case .primary: return "Primary"
        case .red: return "Red"
        case .orange: return "Orange"
        case .yellow: return "Yellow"
        case .green: return "Green"
        case .mint: return "Mint"
        case .teal: return "Teal"
        case .cyan: return "Cyan"
        case .blue: return "Blue"
        case .indigo: return "Indigo"
        case .purple: return "Purple"
        case .pink: return "Pink"
        case .brown: return "Brown"
        case .gray: return "Gray"
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
                SettingsPersistence.default.saveSetting(8, .colorTheme)
                return defaultTheme.color
            }
            
            return theme.color
        }
    )
}

import SwiftUI
import UIKit

extension UIFont {
    static var input: UIFont {
        let font: UIFont = .systemFont(ofSize: .font.default, weight: .bold)
        guard let descriptor = font.fontDescriptor.withDesign(.rounded) else { return font }
        return UIFont(descriptor: descriptor, size: .font.default)
    }
}

extension Font {
    static let title: Font = .system(size: .font.title, weight: .black, design: .rounded)
    static let `default`: Font = .system(size: .font.default, weight: .semibold, design: .rounded)
    static let input: Font = .system(size: .font.default, weight: .bold, design: .rounded)
    static let listItem: Font = .system(size: .font.default, weight: .bold, design: .rounded)
    static let stepper: Font = .system(size: .font.stepper, weight: .bold, design: .rounded)
    static let empoji: Font = .title2
    static let emptyStateEmoji: Font = .system(size: 50)
}

extension Color {
    static let gradientColors: [Color] = [.blue, .green, .yellow]
    
    func emojiBackgroundOpacity(for colorScheme: ColorScheme) -> Color {
        opacity(colorScheme == .light ? 0.1 : 0.2)
    }
    
    func emojiBorderOpacity(for colorScheme: ColorScheme) -> Color {
        opacity(colorScheme == .light ? 0.25 : 0.25)
    }
    
    func stepperBackgroundOpacity(for colorScheme: ColorScheme) -> Color {
        opacity(colorScheme == .light ? 0.1 : 0.2)
    }
    
    static let swipeDelete: Color = .red
}

extension CGFloat {
    struct font {
        static let `default`: CGFloat = 17
        static let title: CGFloat = 32
        static let stepper: CGFloat = 15
    }
    
    struct margin {
        static let horizontal: CGFloat = 12
        static let inputVertical: CGFloat = 8
        static let emptyState: CGFloat = 12
    }
}

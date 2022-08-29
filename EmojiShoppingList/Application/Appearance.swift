import SwiftUI
import UIKit

extension Font {
    static let `default`: Font = .system(size: 17, weight: .semibold, design: .rounded)
    static let listItem: Font = .system(size: 17, weight: .bold, design: .rounded)
    static let stepper: Font = .system(size: 15, weight: .bold, design: .rounded)
}

extension Color {
    func stepperBackgroundOpacity(for colorScheme: ColorScheme) -> Color {
        opacity(colorScheme == .light ? 0.1 : 0.2)
    }
    
    static let swipeDelete: Color = .red
}

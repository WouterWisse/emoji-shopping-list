import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor
    var textColor: UIColor
    
    init(
        backgroundColor: UIColor,
        textColor: UIColor
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: textColor,
            .font: UIFont(name: "Pacifico", size: 20)!
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: textColor,
            .font: UIFont(name: "Pacifico", size: 34)!
        ]
        
        let standardAppearance = appearance.copy()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = .systemBackground
        standardAppearance.shadowColor = textColor
        UINavigationBar.appearance().standardAppearance = standardAppearance
        
        let compactAppearance = appearance.copy()
        compactAppearance.configureWithTransparentBackground()
        compactAppearance.backgroundColor = .clear
        UINavigationBar.appearance().compactAppearance = compactAppearance
        
        UINavigationBar.appearance().scrollEdgeAppearance = compactAppearance
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBarColor(
        backgroundColor: UIColor,
        textColor: UIColor
    ) -> some View {
        self.modifier(
            NavigationBarModifier(
                backgroundColor: backgroundColor,
                textColor: textColor
            )
        )
    }
}

import SwiftUI

struct RoundStepperButtonView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(title, action: action)
            .buttonStyle(.bordered)
            .controlSize(.small)
    }
}

struct RoundStepperButtonView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            RoundStepperButtonView(title: "+", action: {})
                .preferredColorScheme(colorScheme)
                .previewLayout(.sizeThatFits)
                .padding()
            
            RoundStepperButtonView(title: "-", action: {})
                .preferredColorScheme(colorScheme)
                .previewLayout(.sizeThatFits)
                .padding()
        }
        .tint(.blue)
    }
}

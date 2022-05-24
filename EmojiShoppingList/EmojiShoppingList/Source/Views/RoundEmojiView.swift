import SwiftUI

struct RoundEmojiView: View {
    let emoji: String
    let color: Color
    let done: Bool
    
    private let size: CGFloat = 50
    
    var body: some View {
        Text(emoji)
            .font(.title2)
            .multilineTextAlignment(.center)
            .frame(width: size, height: size, alignment: .center)
            .background(color.opacity(done ? 0 : 0.25))
            .cornerRadius(size / 2)
    }
}

struct RoundEmojiView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            Group {
                RoundEmojiView(emoji: "🥑", color: .green, done: false)
                    .preferredColorScheme(colorScheme)
                    .previewLayout(.sizeThatFits)
                    .padding()
                
                RoundEmojiView(emoji: "🫐", color: .blue, done: true)
                    .preferredColorScheme(colorScheme)
                    .previewLayout(.sizeThatFits)
                    .padding()
                
                RoundEmojiView(emoji: "🍓", color: .red, done: false)
                    .preferredColorScheme(colorScheme)
                    .previewLayout(.sizeThatFits)
                    .padding()
            }
        }
    }
}

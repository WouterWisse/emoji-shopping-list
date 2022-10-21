import SwiftUI

struct CompletedEmojiView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let emoji: String
    let color: Color
    
    @State private var coloredCircleScale: CGFloat = 0.0
    @State private var backgroundCircleScale: CGFloat = 0.0
    
    @State private var emojiScale: CGFloat = 0.0
    @State private var emojiOpacity: CGFloat = 1.0
    @State private var animationFinished: Bool = false
    
    var body: some View {
        ZStack {
            if !animationFinished  {
                Circle()
                    .fill(color)
                    .scaleEffect(coloredCircleScale)
                    .frame(width:48, height: 48)
                
                Circle()
                    .fill(Color.backgroundColor)
                    .scaleEffect(backgroundCircleScale)
            }
            
            Text(emoji)
                .font(.emoji)
                .multilineTextAlignment(.center)
                .opacity(emojiOpacity)
                .scaleEffect(emojiScale)
        }
        .frame(width: 50, height: 50)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                coloredCircleScale = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.3).delay(0.2)) {
                backgroundCircleScale = 1.0
            }
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.4)) {
                emojiScale = 1.0
            }
            
            withAnimation(.easeOut.delay(1)) {
                emojiOpacity = 0.5
            }
        }
    }
}

struct CompletedEmojiView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedEmojiView(emoji: "🥦", color: .green)
    }
}

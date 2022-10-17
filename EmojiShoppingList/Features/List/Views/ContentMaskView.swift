import SwiftUI

struct ContentMaskView<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        content()
            .foregroundColor(.clear)
            .overlay {
                LinearGradient(
                    colors: Color.gradientColors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .mask(content)
            }
    }
}

// MARK: Preview

struct ContentMaskView_Previews: PreviewProvider {
    static var previews: some View {
        ContentMaskView {
            Text("Hello World!")
                .font(.title)
        }
    }
}

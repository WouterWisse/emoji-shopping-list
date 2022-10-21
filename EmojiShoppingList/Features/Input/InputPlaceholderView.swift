import SwiftUI

struct InputPlaceholderView<Content: View>: View {
    let content: () -> Content
    private let duration = 0.8
    
    @State private var writing = false
    @State private var movingCursor = false
    @State private var blinkingCursor = false
    
    
    var body: some View {
        content()
            .mask(
                GeometryReader { proxy in
                    Rectangle()
                        .offset(x: writing ? 0 : -proxy.size.width)
                }
            )
            .overlay {
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.secondary)
                        .opacity(blinkingCursor ? 0 : 1)
                        .frame(width: 2, height: 22, alignment: .leading)
                        .offset(x: movingCursor ? proxy.size.width : 0)
                }
            }
            .onAppear {
                withAnimation(.linear(duration: duration).delay(2).repeatForever(autoreverses: true)) {
                    writing.toggle()
                    movingCursor.toggle()
                }
                
                withAnimation(.linear(duration: 0.6).repeatForever(autoreverses: true)) {
                    blinkingCursor.toggle()
                }
            }
    }
}

// MARK: Preview

struct InputPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 16) {
            InputPlaceholderView {
                Text("Onion")
                    .font(.default)
            }
            
            InputPlaceholderView {
                Text("Organic Avocado")
                    .font(.default)
            }
            
            InputPlaceholderView {
                Text("Organic Firm Tofu")
                    .font(.default)
            }
        }
    }
}

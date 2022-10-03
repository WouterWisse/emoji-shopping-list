import SwiftUI

struct EdgeFadeView: View {
    private var color: Color {
        let systemBackgroundColor = UIColor.systemBackground
        return Color(systemBackgroundColor)
    }
    
    var body: some View {
        GeometryReader { geometryReader in
            VStack {
                LinearGradient(
                    colors: [color, color.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.top)
                .frame(height: max(0, geometryReader.safeAreaInsets.top - 50), alignment: .center)
                
                Spacer()
                
                LinearGradient(
                    colors: [color.opacity(0.0), color],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.bottom)
                .frame(height: max(0, geometryReader.safeAreaInsets.bottom - 30), alignment: .center)
            }
        }
    }
}

struct EdgeFadeView_Previews: PreviewProvider {
    static var previews: some View {
        EdgeFadeView()
    }
}

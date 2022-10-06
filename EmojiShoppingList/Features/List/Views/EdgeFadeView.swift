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
                .frame(height: geometryReader.safeAreaInsets.top, alignment: .center)
                
                Spacer()
                
                LinearGradient(
                    colors: [color.opacity(0.0), color],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: geometryReader.safeAreaInsets.bottom, alignment: .center)
            }
            .edgesIgnoringSafeArea([.bottom, .top])
        }
    }
}

struct EdgeFadeView_Previews: PreviewProvider {
    static var previews: some View {
        EdgeFadeView()
    }
}

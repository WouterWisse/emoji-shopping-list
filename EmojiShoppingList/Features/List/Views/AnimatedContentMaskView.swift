import SwiftUI

struct AnimatedContentMaskView<Content: View>: View {
    @State private var progress: CGFloat = 0
    
    private let duration: Double = 2
    private let gradient1 = Gradient(colors: [.blue, .green, .yellow])
    private let gradient2 = Gradient(colors: [.blue, .green, .purple])
    
    var colors: [Color]
    var content: () -> Content
    
    var body: some View {
        content()
            .foregroundColor(.clear)
            .overlay {
                content()
                    .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
                    .mask(content)
            }
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: true)) {
                    self.progress = 1.0
                }
            }
    }
}

// MARK: Gradients

private struct AnimatableGradientModifier: AnimatableModifier {
    let fromGradient: Gradient
    let toGradient: Gradient
    var progress: CGFloat = 0.0
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        var gradientColors = [Color]()
        
        for i in 0..<fromGradient.stops.count {
            let fromColor = UIColor(fromGradient.stops[i].color)
            let toColor = UIColor(toGradient.stops[i].color)
            gradientColors.append(colorMixer(fromColor: fromColor, toColor: toColor, progress: progress))
        }
        
        return LinearGradient(
            gradient: Gradient(colors: gradientColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    func colorMixer(
        fromColor: UIColor,
        toColor: UIColor,
        progress: CGFloat
    ) -> Color {
        guard let fromColor = fromColor.cgColor.components else { return Color(fromColor) }
        guard let toColor = toColor.cgColor.components else { return Color(toColor) }
        
        let red = fromColor[0] + (toColor[0] - fromColor[0]) * progress
        let green = fromColor[1] + (toColor[1] - fromColor[1]) * progress
        let blue = fromColor[2] + (toColor[2] - fromColor[2]) * progress
        
        return Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
}

private extension View {
    func animatableGradient(
        fromGradient: Gradient,
        toGradient: Gradient,
        progress: CGFloat
    ) -> some View {
        self.modifier(
            AnimatableGradientModifier(
                fromGradient: fromGradient,
                toGradient: toGradient,
                progress: progress
            )
        )
    }
}

// MARK: Preview

struct AnimatedContentMaskView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedContentMaskView(colors: [.green, .red]) {
            Text("Hello World!")
                .font(.title)
        }
    }
}

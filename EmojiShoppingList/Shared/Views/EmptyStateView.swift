import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        LinearGradient(
            colors: Color.gradientColors,
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: 140)
        .mask(
            VStack(spacing: 8) {
                HStack {
                    Text("🍇")
                    Text("🍋")
                }
                HStack(spacing: 8) {
                    Text("🍎")
                    Text("🥦")
                }
                Text("List is empty")
                    .font(.system(.body, design: .rounded, weight: .bold))
            }
            .font(.system(size: 40))
        )
        .listRowSeparator(.hidden)
        .frame(width: 200)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyStateView()
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}

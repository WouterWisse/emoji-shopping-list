import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        LinearGradient(
            colors: Color.gradientColors,
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: 240)
        .mask(
            VStack(spacing: .margin.emptyState) {
                HStack(spacing: .margin.emptyState) {
                    Text("🍇")
                    Text("🍋")
                }
                HStack(spacing: .margin.emptyState) {
                    Text("🍎")
                    Text("🥦")
                }
            }
            .font(.emptyStateEmoji)
        )
        .listRowSeparator(.hidden)
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

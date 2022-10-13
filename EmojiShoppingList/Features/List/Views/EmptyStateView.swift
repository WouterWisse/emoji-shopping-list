import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        ContentMaskView(colors: Color.gradientColors) {
            VStack(spacing: .margin.emptyState) {
                HStack(spacing: .margin.emptyState) {
                    Text("🍇")
                    Text("🍑")
                }
                HStack(spacing: .margin.emptyState) {
                    Text("🍎")
                    Text("🥦")
                }
            }
            .font(.emptyStateEmoji)
        }
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

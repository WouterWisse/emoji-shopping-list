import SwiftUI

struct TitleView: View {
    var body: some View {
        LinearGradient(
            colors: Color.gradientColors,
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(
            height: 40,
            alignment: .leading
        )
        .mask(
            Text("Shopping List")
                .font(.header)
                .frame(
                    maxWidth: .infinity,
                    minHeight: 40,
                    maxHeight: 40,
                    alignment: .leading
                )
        )
        .listRowSeparator(.hidden)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
            .padding()
    }
}

import SwiftUI

struct TitleView: View {
    var body: some View {
        LinearGradient(
            colors: Color.headerColors,
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: 230, height: 40)
        .mask(
            Text("Shopping List")
                .font(.header)
                .frame(width: 230, height: 40)
        )
        .padding(.top, 16)
        .listRowSeparator(.hidden)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
            .padding()
    }
}

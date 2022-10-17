import SwiftUI

struct TitleView: View {
    var body: some View {
        HStack {
            ContentMaskView {
                Text("Shopping List")
                    .font(.title)
            }
            Spacer()
        }
        .frame(height: 40, alignment: .leading)
        .listRowSeparator(.hidden)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
            .padding()
    }
}

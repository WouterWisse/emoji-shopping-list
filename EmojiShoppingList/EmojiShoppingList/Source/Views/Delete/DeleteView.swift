import SwiftUI

struct DeleteView: View {
    var body: some View {
        VStack(spacing: 12) {
            Button(role: .destructive) {
                // Delete all
            } label: {
                Text("Delete all items from list")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                // Delete all
            } label: {
                Text("Delete all striked items from list")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.bordered)
            
            Button {
                // Delete all
            } label: {
                Text("Cancel")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.plain)
        }
    }
}

struct DeleteView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            DeleteView()
                .padding()
                .preferredColorScheme(colorScheme)
        }
    }
}

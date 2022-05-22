import SwiftUI

struct DeleteView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            RoundEmojiView(emoji: "🗑", color: .red)
            
            Spacer()
                .frame(height: 8, alignment: .center)
            
            Button(role: .destructive) {
                isPresented.toggle()
            } label: {
                Text("Delete all items from list")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                isPresented.toggle()
            } label: {
                Text("Delete all striked items from list")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.bordered)
            
            Button {
                isPresented.toggle()
            } label: {
                Text("Cancel")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct DeleteView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            DeleteView(isPresented: .constant(true))
                .padding()
                .preferredColorScheme(colorScheme)
        }
    }
}

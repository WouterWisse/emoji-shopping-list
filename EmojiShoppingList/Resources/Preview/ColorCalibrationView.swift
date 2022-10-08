import SwiftUI
import CoreData

struct ColorCalibrationView: View {
    private let items: [ListItem] = [
        .mock(title: "Banana", emoji: "🍌"),
        .mock(title: "Avocado", emoji: "🥑"),
        .mock(title: "Grapes", emoji: "🍇"),
        .mock(title: "Blueberries", emoji: "🫐"),
        .mock(title: "Apple", emoji: "🍎"),
        .mock(title: "Croissant", emoji: "🥐")
    ]
    
    var body: some View {
        VStack {
            ForEach(items, id: \.createdAt) { item in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .padding()
                        .foregroundColor(.white)
                        .background(item.color)
                    
                    RoundEmojiView(item: item)
                        .padding()
                }
                .padding()
            }
        }
    }
}

private extension ListItem {
    static func mock(title: String, emoji: String) -> ListItem {
        let color = emoji
            .toImage()?
            .averageColor?
            .adjust(brightness: 0.55)
        
        return ListItem(
            id: NSManagedObjectID(),
            title: title,
            emoji: emoji,
            color: Color(color ?? .gray),
            completed: false,
            amount: 1,
            createdAt: Date()
        )
    }
}

struct ColorCalibrationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ColorCalibrationView()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            ColorCalibrationView()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

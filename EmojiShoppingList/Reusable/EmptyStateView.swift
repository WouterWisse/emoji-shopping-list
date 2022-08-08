import SwiftUI

struct EmptyStateView: View {
    var height: CGFloat = UIScreen.main.bounds.size.height / 2
    
    private let emoji = ["🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍑", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄", "🥜", "🫘", "🌰", "🍞", "🥐", "🥖", "🫓", "🥨", "🥯", "🥞", "🧇", "🧀", "🍖", "🍗", "🥩", "🥓", "🍟", "🍕", "🥚", "🍿", "🥫", "🍠", "🍣", "🍤", "🥮", "🥟", "🥠", "🦪", "🍩", "🍪", "🎂", "🍰", "🧁", "🥧", "🍫", "🍬", "🍭"]
    
    private var randomEmptyText: String {
        let firstUniqueEmoji = emoji.randomElement()!
        var secondUniqueEmoji = emoji.randomElement()!
        var thirdUniqueEmoji = emoji.randomElement()!
        
        while secondUniqueEmoji == firstUniqueEmoji {
            secondUniqueEmoji = emoji.randomElement()!
        }
        while thirdUniqueEmoji == firstUniqueEmoji || thirdUniqueEmoji == secondUniqueEmoji {
            thirdUniqueEmoji = emoji.randomElement()!
        }
        
        return "\(firstUniqueEmoji) \(secondUniqueEmoji) \(thirdUniqueEmoji)"
    }
    
    var body: some View {
        Text(randomEmptyText)
            .font(.largeTitle)
            .frame(
                maxWidth: .infinity,
                minHeight: height,
                maxHeight: height,
                alignment: .center
            )
            .listRowSeparator(.hidden)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyStateView(height: 40)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}

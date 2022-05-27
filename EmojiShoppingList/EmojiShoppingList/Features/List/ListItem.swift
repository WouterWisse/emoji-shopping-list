import SwiftUI
import ComposableArchitecture
import CoreData

// MARK: Logic

struct ListItem: Equatable, Identifiable {
    let id: NSManagedObjectID
    let title: String
    var isDone: Bool
    var amount: Int16
    let createdAt: Date
    
    init(item: Item) {
        self.id = item.objectID
        self.title = item.title!
        self.isDone = item.done
        self.amount = item.amount
        self.createdAt = item.createdAt!
    }
    
    init(
        id: NSManagedObjectID,
        title: String,
        done: Bool,
        amount: Int16,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.isDone = done
        self.amount = amount
        self.createdAt = createdAt
    }
}

enum ListItemAction: Equatable {
    
}

struct ListItemEnvironment {
    
}

let listItemReducer = Reducer<
    ListItem,
    ListItemAction,
    ListItemEnvironment
> { state, action, environment in
    switch action {

    }
}

// MARK: - Views

struct ListItemView: View {
    let item: Item
    
    @State private var amount: Int = 1
    
    
    var body: some View {
        HStack(spacing: 12) {
            RoundEmojiView(
                emoji: item.emojiString,
                color: item.color,
                done: item.done
            )
            
            Text(item.title ?? "")
                .font(.headline)
                .strikethrough(item.done)
            
            Spacer()
            
            if !item.done {
                HStack(spacing: 4) {
                    RoundStepperButtonView(
                        title: "-",
                        action: decrease
                    )
                    .tint(item.color)
                    
                    Text("\(self.amount)")
                        .font(.headline)
                        .foregroundColor(item.color)
                        .frame(width: 30, height: 20, alignment: .center)
                    
                    RoundStepperButtonView(
                        title: "+",
                        action: increase
                    )
                    .tint(item.color)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func increase() {
        Haptics.shared.play(.light)
        amount += 1
    }
    
    private func decrease() {
        Haptics.shared.play(.light)
        amount -= 1
    }
}

//struct ListItemView_Previews: PreviewProvider {
//    static let items: [Item] = [PersistenceController.previewItem, PersistenceController.previewDoneItem]
//    static let colorSchemes: [ColorScheme] = [.light, .dark]
//
//    static var previews: some View {
//        ForEach(items, id: \.self) { item in
//            ForEach(colorSchemes, id: \.self) { colorScheme in
//                ListItemView(item: item)
//                    .preferredColorScheme(colorScheme)
//                    .previewLayout(.sizeThatFits)
//                    .padding()
//            }
//        }
//    }
//}

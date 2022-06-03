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
        isDone: Bool,
        amount: Int16,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.amount = amount
        self.createdAt = createdAt
    }
}

enum ListItemAction: Equatable {
    case incrementAmount
    case decrementAmount
    case delete
    case toggleDone
}

struct ListItemEnvironment {}

let listItemReducer = Reducer<
    ListItem,
    ListItemAction,
    SharedEnvironment<ListItemEnvironment>
> { state, action, environment in
    switch action {
    case .incrementAmount:
        environment.feedbackGenerator().impact(.soft)
        state.amount += 1
        return .none
        
    case .decrementAmount:
        environment.feedbackGenerator().impact(.soft)
        if state.amount > 1 {
            state.amount -= 1
        }
        return .none
        
    case .delete:
        environment.feedbackGenerator().impact(.rigid)
        return .none
        
    case .toggleDone:
        state.isDone.toggle()
        environment.feedbackGenerator().impact(.rigid)
        return .none
    }
}

// MARK: - Views

struct ListItemView: View {
    let store: Store<ListItem, ListItemAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: 12) {
                RoundEmojiView(
                    emoji: viewStore.emojiString,
                    color: viewStore.color,
                    done: viewStore.isDone
                )
                
                Text(viewStore.state.title)
                    .font(.headline)
                    .strikethrough(viewStore.state.isDone)
                
                Spacer()
                
                if !viewStore.isDone {
                    HStack(spacing: 4) {
                        RoundStepperButtonView(
                            title: "-",
                            action: { viewStore.send(.decrementAmount) }
                        )
                        .tint(viewStore.color)
                        
                        Text("\(viewStore.amount)")
                            .font(.headline)
                            .foregroundColor(viewStore.color)
                            .frame(width: 30, height: 20, alignment: .center)
                        
                        RoundStepperButtonView(
                            title: "+",
                            action: { viewStore.send(.incrementAmount) }
                        )
                        .tint(viewStore.color)
                    }
                }
            }
            .swipeActions(edge: .leading) {
                Button {
                    withAnimation {
                        viewStore.send(.toggleDone)
                    }
                } label: {
                    if viewStore.isDone {
                        Label("Remove", systemImage: "arrow.uturn.right.circle.fill")
                    } else {
                        Label("Add", systemImage: "checkmark.circle.fill")
                    }
                    
                }
                .tint(viewStore.color)
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    withAnimation {
                        viewStore.send(.delete)
                    }
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
            .padding(.vertical, 8)
        }
    }
}

extension ListItem {
    var color: Color {
        var colorDict: [String: Color] = [:]
        colorDict["Avocado"] = .green
        colorDict["Banana"] = .yellow
        colorDict["Cheese"] = .yellow
        colorDict["Broccoli"] = .green
        colorDict["Tofu"] = .white
        colorDict["Beer"] = .brown
        colorDict["Bread"] = .brown
        colorDict["Strawberries"] = .red
        colorDict["Blueberries"] = .blue
        colorDict["Pepper"] = .red
        colorDict["Bell pepper"] = .green
        colorDict["Apple"] = .red
        colorDict["Onion"] = .brown
        colorDict["Orange"] = .orange
        colorDict["Wine"] = .red
        colorDict["Red Wine"] = .red
        colorDict["White Wine"] = .gray
        colorDict["Eggs"] = .gray
        colorDict["Milk"] = .gray
        colorDict["Champagne"] = .brown
        colorDict["Corn"] = .yellow
        colorDict["Beans"] = .brown
        colorDict["Tacos"] = .yellow
        colorDict["Tomato"] = .red
        colorDict["Guacamole"] = .green
        colorDict["Lemon"] = .yellow
        colorDict["Lime"] = .green
        colorDict["Carrot"] = .orange
        colorDict["Eggplant"] = .indigo
        colorDict["Zucchini"] = .green
        colorDict["Cucumber"] = .green
        colorDict["Garlic"] = .brown
        colorDict["Green"] = .green
        colorDict["Leaves"] = .green
        colorDict["Spinach"] = .green
        colorDict["Salad"] = .green
        colorDict["Bacon"] = .brown
        colorDict["Meat"] = .red
        colorDict["Fish"] = .teal
        colorDict["Shrimp"] = .red
        colorDict["Sweet potato"] = .indigo
        colorDict["Peanuts"] = .brown
        colorDict["Peanut butter"] = .brown
        colorDict["Tomato saus"] = .red
        colorDict["Red saus"] = .red
        colorDict["Kiwi"] = .green
        colorDict["Melon"] = .green
        colorDict["Pear"] = .green
        colorDict["Water melon"] = .red
        colorDict["Grapes"] = .pink
        colorDict["Peach"] = .orange
        colorDict["Pineapple"] = .yellow
        
        // Check for direct match
        let directMatch = colorDict.first { key, color in
            return key.lowercased() == title.lowercased()
        }
        
        if let color = directMatch?.value {
            return color
        }
        
        // Check for containing match
        let containingMatch = colorDict.first { key, color in
            return key.lowercased().contains(title.lowercased())
        }
        
        return containingMatch?.value ?? .gray
    }
    
    var emojiString: String {
        var emojiDict: [String: String] = [:]
        emojiDict["Avocado"] = "🥑"
        emojiDict["Banana"] = "🍌"
        emojiDict["Cheese"] = "🧀"
        emojiDict["Broccoli"] = "🥦"
        emojiDict["Tofu"] = "🤷🏼‍♂️"
        emojiDict["Beer"] = "🍺"
        emojiDict["Bread"] = "🍞"
        emojiDict["Strawberries"] = "🍓"
        emojiDict["Blueberries"] = "🫐"
        emojiDict["Pepper"] = "🌶"
        emojiDict["Bell pepper"] = "🫑"
        emojiDict["Apple"] = "🍎"
        emojiDict["Onion"] = "🧅"
        emojiDict["Orange"] = "🍊"
        emojiDict["Wine"] = "🍷"
        emojiDict["Red Wine"] = "🍷"
        emojiDict["White Wine"] = "🍾"
        emojiDict["Eggs"] = "🥚"
        emojiDict["Milk"] = "🥛"
        emojiDict["Champagne"] = "🍾"
        emojiDict["Corn"] = "🌽"
        emojiDict["Beans"] = "🫘"
        emojiDict["Tacos"] = "🌮"
        emojiDict["Tomato"] = "🍅"
        emojiDict["Guacamole"] = "🥑"
        emojiDict["Lemon"] = "🍋"
        emojiDict["Lime"] = "🍋"
        emojiDict["Carrot"] = "🥕"
        emojiDict["Eggplant"] = "🍆"
        emojiDict["Zucchini"] = "🥒"
        emojiDict["Cucumber"] = "🥒"
        emojiDict["Garlic"] = "🧄"
        emojiDict["Green"] = "🥬"
        emojiDict["Leaves"] = "🥬"
        emojiDict["Spinach"] = "🥬"
        emojiDict["Salad"] = "🥬"
        emojiDict["Bacon"] = "🥓"
        emojiDict["Meat"] = "🥩"
        emojiDict["Fish"] = "🐟"
        emojiDict["Shrimp"] = "🦐"
        emojiDict["Sweet potato"] = "🍠"
        emojiDict["Peanuts"] = "🥜"
        emojiDict["Peanut butter"] = "🥜"
        emojiDict["Tomato saus"] = "🥫"
        emojiDict["Red saus"] = "🥫"
        emojiDict["Kiwi"] = "🥝"
        emojiDict["Melon"] = "🍈"
        emojiDict["Pear"] = "🍐"
        emojiDict["Water melon"] = "🍉"
        emojiDict["Grapes"] = "🍇"
        emojiDict["Peach"] = "🍑"
        emojiDict["Pineapple"] = "🍍"
        
        // Check for direct match
        let directMatch = emojiDict.first { key, emoji in
            return key.lowercased() == title.lowercased()
        }
        
        if let emoji = directMatch?.value {
            return emoji
        }
        
        // Check for containing match
        let containingMatch = emojiDict.first { key, emoji in
            return key.lowercased().contains(title.lowercased())
        }
        
        return containingMatch?.value ?? "🤷🏼‍♂️"
    }
}

// MARK: Preview

struct ListItemView_Previews: PreviewProvider {
    static let previewItems: IdentifiedArrayOf<ListItem> = .preview
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(previewItems) { item in
            ForEach(colorSchemes, id: \.self) { colorScheme in
                ListItemView(
                    store: Store(
                        initialState: item,
                        reducer: listItemReducer,
                        environment: .preview(environment: ListItemEnvironment())
                    )
                )
                .preferredColorScheme(colorScheme)
                .previewLayout(.sizeThatFits)
                .padding()
            }
        }
    }
}

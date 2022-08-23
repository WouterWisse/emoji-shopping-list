import SwiftUI
import ComposableArchitecture
import CoreData

// MARK: Logic

struct ListItem: Equatable, Identifiable {
    let id: NSManagedObjectID
    let title: String
    let emoji: String
    var isDone: Bool
    var amount: Int16
    let createdAt: Date
    
    init(item: Item) {
        self.id = item.objectID
        self.title = item.title!
        self.emoji = item.emoji ?? "🤷‍♂️"
        self.isDone = item.done
        self.amount = item.amount
        self.createdAt = item.createdAt!
    }
    
    init(
        id: NSManagedObjectID,
        title: String,
        emoji: String,
        isDone: Bool,
        amount: Int16,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
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
        return .none
        
    case .toggleDone:
        state.isDone.toggle()
        environment.feedbackGenerator().impact(.rigid)
        return .none
    }
}
.debug()

// MARK: - Views

struct ListItemView: View {
    let store: Store<ListItem, ListItemAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: 12) {
                RoundEmojiView(
                    emoji: viewStore.emoji,
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
                        Image(systemName: "arrow.uturn.right.circle.fill")
                    } else {
                        Image(systemName: "checkmark.circle.fill")
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
                    Image(systemName: "trash.fill")
                }
                .tint(Color.red)
            }
            .padding(.vertical, 8)
        }
    }
}

// TODO: Add animation where color and emoji pop in
// Even better, because then we can do the async color check.

extension ListItem {
    var color: Color {
        if let image = emoji.textToImage(),
           let color = image.getColors(quality: .lowest) {
            return Color(color.background)
        }
        return .gray
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

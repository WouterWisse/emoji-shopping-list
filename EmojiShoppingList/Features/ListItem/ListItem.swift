import SwiftUI
import ComposableArchitecture
import CoreData
import Pow

// MARK: Logic

struct ListItem: Equatable, Identifiable {
    let id: NSManagedObjectID
    let title: String
    let emoji: String
    let color: Color
    var isDone: Bool
    var amount: Int16
    let createdAt: Date
    
    init(item: Item) {
        self.id = item.objectID
        self.title = item.title!
        self.emoji = item.emoji ?? "🤷‍♂️"
        self.color = Color(item.color as? UIColor ?? .gray)
        self.isDone = item.done
        self.amount = item.amount
        self.createdAt = item.createdAt!
    }
    
    init(
        id: NSManagedObjectID,
        title: String,
        emoji: String,
        color: Color,
        isDone: Bool,
        amount: Int16,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.color = color
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
                if viewStore.isDone {
                    RoundEmojiView(
                        emoji: viewStore.emoji,
                        color: viewStore.color,
                        done: viewStore.isDone
                    )
                    .transition(.movingParts.pop(.init(viewStore.color)))
                } else {
                    RoundEmojiView(
                        emoji: viewStore.emoji,
                        color: viewStore.color,
                        done: viewStore.isDone
                    )
                    .transition(.identity)
                }
                
                Text(viewStore.title)
                    .font(.headline)
                    .strikethrough(viewStore.isDone)
                
                Spacer()
                
                if !viewStore.isDone {
                    ZStack {
                        Capsule()
                            .fill(viewStore.color.opacity(0.1))
                            .frame(width: 100, height: 40)
                        
                        Capsule()
                            .strokeBorder(viewStore.color.opacity(0.25), lineWidth: 2)
                            .frame(width: 100, height: 40)
                        
                        HStack(spacing: 0) {
                            Button(action: {
                                viewStore.send(.decrementAmount)
                            }, label: {
                                Image(systemName: "minus")
                            })
                            .buttonStyle(.borderless)
                            .frame(width: 30, height: 30, alignment: .center)

                            Text("\(viewStore.amount)")
                                .foregroundColor(viewStore.color)
                                .frame(width: 24, height: 20, alignment: .center)
                            
                            Button(action: {
                                viewStore.send(.incrementAmount)
                            }, label: {
                                Image(systemName: "plus")
                            })
                            .buttonStyle(.borderless)
                            .frame(width: 30, height: 30, alignment: .center)
                            
                        }
                        .font(.system(size: 15, weight: .bold, design: .rounded))
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

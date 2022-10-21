import Foundation
import SwiftUI
import ComposableArchitecture
import CoreData

// MARK: Logic

struct ListItem: Equatable, Identifiable {
    let id: NSManagedObjectID
    let title: String
    let emoji: String
    let color: Color
    var completed: Bool
    var amount: Int16
    let createdAt: Date
    
    var isStepperExpanded: Bool = false
    var isMarkedAsComplete: Bool = false
    
    init(item: Item) {
        self.id = item.objectID
        self.title = item.title!
        self.emoji = item.emoji ?? "🤷‍♂️"
        self.color = Color(item.color as? UIColor ?? .gray)
        self.completed = item.completed
        self.amount = item.amount
        self.createdAt = item.createdAt!
    }
    
    init(
        id: NSManagedObjectID,
        title: String,
        emoji: String,
        color: Color,
        completed: Bool,
        amount: Int16,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.color = color
        self.completed = completed
        self.amount = amount
        self.createdAt = createdAt
    }
}

enum ListItemAction: Equatable {
    enum UpdateAmountType {
        case increment, decrement
    }
    case stepperTapped
    case expandStepper(expand: Bool)
    case updateAmount(type: UpdateAmountType)
    case delete
    case toggleCompletion
}

struct ListItemEnvironment {}

let listItemReducer = Reducer<
    ListItem,
    ListItemAction,
    SharedEnvironment<ListItemEnvironment>
> { state, action, environment in
    switch action {
    case .stepperTapped:
        return .task { .expandStepper(expand: true) }
            .animation(.easeInOut)
        
    case .expandStepper(let expand):
        state.isStepperExpanded = expand
        if !expand { return .none }
        environment.feedbackGenerator().impact(.soft)
        return .task {
            try await environment.mainQueue().sleep(for: .seconds(3))
            return .expandStepper(expand: false)
        }
        .animation()
        .cancellable(id: state.id, cancelInFlight: true)
        
    case .updateAmount(let type):
        environment.feedbackGenerator().impact(.soft)
        if type == .increment {
            state.amount += 1
        } else if state.amount > 1 {
            state.amount -= 1
        }
        return .task { [state] in
            try await environment.mainQueue().sleep(for: .seconds(2))
            try await environment.persistence().update(state)
            return .expandStepper(expand: false)
        }
        .animation()
        .cancellable(id: state.id, cancelInFlight: true)
        
    case .delete:
        return .none
        
    case .toggleCompletion:
        state.completed.toggle()
        if state.completed {
            state.isMarkedAsComplete = true
            environment.feedbackGenerator().notify(.success)
        } else {
            environment.feedbackGenerator().impact(.rigid)
        }
        return .none
    }
}
.debug()

// MARK: - Views

struct ListItemView: View {
    @Environment(\.colorScheme) private var colorScheme
    let store: Store<ListItem, ListItemAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: .margin.horizontal) {
                
                if viewStore.completed && viewStore.isMarkedAsComplete {
                    CompletedEmojiView(
                        emoji: viewStore.emoji,
                        color: viewStore.color
                    )
                } else {
                    EmojiView(item: viewStore.state)
                        .opacity(viewStore.completed ? 0.5 : 1)
                }
                
                
                Text(viewStore.title)
                    .font(.listItem)
                    .strikethrough(viewStore.completed)
                    .opacity(viewStore.completed ? 0.3 : 1)
                
                Spacer()
                
                if !viewStore.completed {
                    ZStack {
                        Capsule()
                            .fill(viewStore.color.stepperBackgroundOpacity(for: colorScheme))
                            .frame(width: viewStore.isStepperExpanded ? 100 : 40, height: 40)
                        
                        Capsule()
                            .strokeBorder(viewStore.color.stepperBackgroundOpacity(for: colorScheme), lineWidth: 2)
                            .frame(width: viewStore.isStepperExpanded ? 100 : 40, height: 40)
                            .overlay(
                                HStack(spacing: 0) {
                                    if viewStore.isStepperExpanded {
                                        Button(action: {
                                            viewStore.send(.updateAmount(type: .decrement))
                                        }, label: {
                                            Image(systemName: "minus")
                                        })
                                        .buttonStyle(.borderless)
                                        .frame(width: 30, height: 30, alignment: .center)
                                    }
                                    
                                    Text("\(viewStore.amount)")
                                        .foregroundColor(viewStore.color)
                                        .frame(width: 24, height: 20, alignment: .center)
                                    
                                    if viewStore.isStepperExpanded {
                                        Button(action: {
                                            viewStore.send(.updateAmount(type: .increment))
                                        }, label: {
                                            Image(systemName: "plus")
                                        })
                                        .buttonStyle(.borderless)
                                        .frame(width: 30, height: 30, alignment: .center)
                                    }
                                }
                                    .font(.stepper)
                                    .tint(viewStore.color)
                                    .clipped()
                            )
                    }
                    .onTapGesture {
                        viewStore.send(.stepperTapped)
                    }
                }
            }
            .swipeActions(edge: .leading) {
                Button {
                    viewStore.send(.toggleCompletion, animation: .default)
                } label: {
                    Image(systemName: viewStore.completed ? "arrow.uturn.right.circle.fill" : "checkmark.circle.fill")
                }
                .tint(viewStore.color)
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    viewStore.send(.delete, animation: .default)
                } label: {
                    Image(systemName: "trash.fill")
                }
                .tint(.swipeDelete)
            }
            .frame(height: 60)
            .alignmentGuide(.listRowSeparatorLeading) {
                $0[.leading]
            }
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

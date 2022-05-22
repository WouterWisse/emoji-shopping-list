import SwiftUI
import CoreData
import SlideOverCard

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdAt, ascending: false)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    @State private var text: String = ""
    @FocusState private var isAddItemTextFieldFocussed: Bool
    
    @State private var isDeletePresented: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Search
                    HStack(spacing: 12) {
                        Text("✏️")
                            .font(.title2)
                            .frame(width: 50, height: 50, alignment: .center)
                            .multilineTextAlignment(.center)
                        
                        TextField("", text: $text, prompt: Text("Add new item"))
                            .font(.headline)
                            .focused($isAddItemTextFieldFocussed)
                            .onSubmit(onSubmit)
                            .onAppear {
                                if items.isEmpty {
                                    withAnimation {
                                        isAddItemTextFieldFocussed = true
                                    }
                                }
                            }
                        
                        Spacer()
                        
                        if isAddItemTextFieldFocussed {
                            Button {
                                withAnimation {
                                    isAddItemTextFieldFocussed = false
                                }
                            } label: {
                                Image(systemName: "keyboard.chevron.compact.down")
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.regular)
                        }
                    }
                    .listRowSeparatorTint(.clear)
                    
                    // Items
                    
                    ForEach(items) { item in
                        ListItemView(item: item)
                            .frame(minHeight: 50, maxHeight: 50)
                            .swipeActions(edge: .leading) {
                                Button {
                                    done(item: item)
                                } label: {
                                    if item.done {
                                        Label("Added", systemImage: "cart.fill.badge.minus")
                                    } else {
                                        Label("Added", systemImage: "cart.fill.badge.plus")
                                    }
                                    
                                }
                                .tint(item.color)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    delete(item: item)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                    }
                    .listRowInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
                if items.isEmpty {
                    VStack(alignment: .center, spacing: 12) {
                        Text("🛒")
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                        Text("Your list is empty")
                            .font(.body)
                            .foregroundColor(.primary.opacity(0.5))
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Hoi
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isDeletePresented.toggle()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .slideOverCard(isPresented: $isDeletePresented) {
                DeleteView(isPresented: $isDeletePresented)
            }
            .navigationTitle("Groceries 🥦")
        }
    }
    
    private func onSubmit() {
        guard !text.isEmpty else {
            return isAddItemTextFieldFocussed = false
        }
        
        addItem()
        text = ""
        isAddItemTextFieldFocussed = true
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move items")
    }
    
    private func addItem() {
        Haptics.shared.play(.medium)
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.title = text
            newItem.emoji = "🤷🏼‍♂️"
            newItem.createdAt = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func done(item: Item) {
        Haptics.shared.notify(.success)
        withAnimation {
            item.done.toggle()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func delete(item: Item) {
        Haptics.shared.notify(.success)
        withAnimation {
            viewContext.delete(item)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

extension Item {
    var color: Color {
        guard let title = title else { return .gray }
        switch title {
        case "Avocado": return .green
        case "Banana": return .yellow
        case "Cheese": return .yellow
        case "Broccoli": return .green
        case "Tofu": return .white
        case "Beer": return .brown
        case "Bread": return .brown
        case "Strawberries": return .red
        case "Blueberries": return .blue
        case "Pepper": return .red
        case "Red pepper": return .red
        case "Apple": return .red
        case "Onion": return .brown
        case "Orange": return .orange
        case "Wine": return .red
        case "Red Wine": return .red
        case "White Wine": return .gray.opacity(0.5)
        case "Eggs": return .gray.opacity(0.5)
        case "Milk": return .gray.opacity(0.5)
        case "Champagne": return .brown
        default: return .gray
        }
    }
    
    var emojiString: String {
        guard let title = title else { return "🤷🏼‍♂️" }
        switch title {
        case "Avocado": return "🥑"
        case "Banana": return "🍌"
        case "Cheese": return "🧀"
        case "Broccoli": return "🥦"
        case "Tofu": return "🤷🏼‍♂️"
        case "Beer": return "🍺"
        case "Bread": return "🍞"
        case "Strawberries": return "🍓"
        case "Blueberries": return "🫐"
        case "Pepper": return "🌶"
        case "Apple": return "🍎"
        case "Onion": return "🧅"
        case "Orange": return "🍊"
        case "Wine": return "🍷"
        case "Red Wine": return "🍷"
        case "White Wine": return "🍷"
        case "Champagne": return "🍾"
        case "Eggs": return "🥚"
        case "Milk": return "🥛"
        default: return "🤷🏼‍♂️"
        }
    }
}

struct RoundStepperButtonView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(title, action: action)
            .buttonStyle(.bordered)
            .controlSize(.small)
    }
}

struct ListView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            ListView()
                .preferredColorScheme(colorScheme)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

final class Haptics {
    static let shared = Haptics()
    
    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}

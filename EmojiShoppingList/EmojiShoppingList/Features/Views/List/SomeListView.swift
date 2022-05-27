import SwiftUI
import CoreData
import SlideOverCard

struct SomeListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdAt, ascending: false)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    @State private var text: String = ""
    @FocusState private var isAddItemTextFieldFocussed: Bool
    
    @State private var isDeletePresented: Bool = false
    @State private var isSettingsPresented: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                // Input
                if isDeletePresented {
                    deleteView
                } else {
                    inputView
                }
                
                // Items
                
                ForEach(items) { item in
                    ListItemView(item: item)
                        .swipeActions(edge: .leading) {
                            Button {
                                done(item: item)
                            } label: {
                                if item.done {
                                    Label("Remove", systemImage: "arrow.uturn.right.circle.fill")
                                } else {
                                    Label("Add", systemImage: "checkmark.circle.fill")
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
                
                // Empty list

                if items.isEmpty {
                    VStack {
                        Text("👀")
                            .font(.largeTitle)
                        Text("Nothing on your list yet")
                            .font(.headline)
                            .opacity(0.25)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isSettingsPresented.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isDeletePresented.toggle()
                        }
                    } label: {
                        Image(systemName: isDeletePresented ? "trash.slash" : "trash")
                    }
                }
            }
            .sheet(isPresented: $isSettingsPresented, content: {
                SettingsView()
            })
            .navigationTitle("List")
        }
    }
    
    var inputView: some View {
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
                .tint(.accentColor)
            }
        }
        .listRowSeparatorTint(.clear)
    }
    
    var deleteView: some View {
        HStack(spacing: 12) {
            Text("🗑")
                .font(.title2)
                .frame(width: 50, height: 50, alignment: .center)
                .multilineTextAlignment(.center)
            
            Button {
                //
            } label: {
                Text("All (12)")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .tint(.red)
            
            Button {
                //
            } label: {
                Text("Striked (5)")
                    .strikethrough(true, color: .red.opacity(0.5))
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(.red)
            
            Button {
                withAnimation {
                    isDeletePresented.toggle()
                }
            } label: {
                Text("Cancel")
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .listRowSeparatorTint(.clear)
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
        colorDict["White Wine"] = .gray.opacity(0.5)
        colorDict["Eggs"] = .gray.opacity(0.5)
        colorDict["Milk"] = .gray.opacity(0.5)
        colorDict["Champagne"] = .brown
        colorDict["Corn"] = .yellow
        colorDict["Beans"] = .brown
        colorDict["Tacos"] = .yellow
        colorDict["Tomato"] = .red
        colorDict["Guacamole"] = .green
        colorDict["Lemon"] = .yellow
        colorDict["Lime"] = .green
        
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
        guard let title = title else { return "🤷🏼‍♂️" }
        
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

struct SomeListView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            SomeListView()
                .preferredColorScheme(colorScheme)
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

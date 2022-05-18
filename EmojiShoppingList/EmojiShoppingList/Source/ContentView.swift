import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var text: String = ""
    @FocusState private var isAddItemTextFieldFocussed: Bool

    var body: some View {
        NavigationView {
            List {
                
                // Search
                HStack(spacing: 12) {
                    Text("🛒")
                        .font(.title2)
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(.gray.opacity(0.1))
                        .multilineTextAlignment(.center)
                        .cornerRadius(25)
                    
                    TextField("", text: $text, prompt: Text("Add new item"))
                    .font(.headline)
                    .focused($isAddItemTextFieldFocussed)
                    .onSubmit {
                        addItem()
                        text = ""
                        isAddItemTextFieldFocussed = true
                    }
                    
                    Spacer()
                    
                    if isAddItemTextFieldFocussed == true {
                        Button {
                            withAnimation {
                                isAddItemTextFieldFocussed = false
                            }
                        } label: {
                            HStack {
                                Text("✓")
                                Image(systemName: "keyboard.chevron.compact.down")
                            }
                        }
                        .frame(width: 60, height: 30, alignment: .center)
                        .foregroundColor(.white)
                        .background(.green)
                        .cornerRadius(6)
                    }
                }
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                    
                ForEach(items) { item in
                    ListItem(title: "Avocado", emoji: "🥑", color: .green)
                        .frame(minHeight: 50, maxHeight: 50)
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: move)
                .listRowInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
                .listRowBackground(Color.clear)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Shopping 🛍")
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move items")
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ListItem: View {
    let title: String
    let emoji: String
    let color: Color
    @State private var amount: Int = 1
    
    private let backgroundColor: Color = .gray
    private let buttonColor: Color = .accentColor
    
    var body: some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.title2)
                .frame(width: 50, height: 50, alignment: .center)
                .background(color.opacity(0.1))
                .multilineTextAlignment(.center)
                .cornerRadius(25)
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("\(self.amount)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(width: 20, alignment: .center)
                
                Stepper("Step", onIncrement: { amount += 1 }, onDecrement: { amount -= 1 })
                    .labelsHidden()
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self, content: { colorScheme in
            Group {
                ContentView()
                    .preferredColorScheme(colorScheme)
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
        })
    }
}

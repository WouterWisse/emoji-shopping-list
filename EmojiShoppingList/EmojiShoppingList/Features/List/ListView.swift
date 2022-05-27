import ComposableArchitecture
import SwiftUI

struct ListView: View {
    let store: Store<ListState, ListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.items) { item in
                        Text(item.title)
                            .font(.headline)
                            .strikethrough(item.isDone, color: .primary)
                            .frame(height: 50, alignment: .leading)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(
            store: Store(
                initialState: ListState(),
                reducer: listReducer,
                environment: ListEnvironment(
                    persistence: PersistenceController.mock
                )
            )
        )
    }
}

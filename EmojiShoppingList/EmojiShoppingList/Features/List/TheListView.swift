import ComposableArchitecture
import SwiftUI

struct TheListView: View {
    let store: Store<ListState, ListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.items) { item in
                        Text(item.title)
                            .font(.headline)
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

struct TheListView_Previews: PreviewProvider {
    static var previews: some View {
        TheListView(
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

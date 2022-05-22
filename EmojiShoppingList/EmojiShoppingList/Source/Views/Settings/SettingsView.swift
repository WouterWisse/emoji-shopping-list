import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {

            }
            .listStyle(.plain)
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

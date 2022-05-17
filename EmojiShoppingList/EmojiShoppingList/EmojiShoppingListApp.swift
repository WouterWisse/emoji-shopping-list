//
//  EmojiShoppingListApp.swift
//  EmojiShoppingList
//
//  Created by Wouter Wisse on 17/05/2022.
//

import SwiftUI

@main
struct EmojiShoppingListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

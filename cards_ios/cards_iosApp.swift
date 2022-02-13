//
//  cards_iosApp.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 2/13/22.
//

import SwiftUI

@main
struct cards_iosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

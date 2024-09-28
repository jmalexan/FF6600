//
//  HackeryApp.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/14/24.
//

import SwiftUI
import SwiftData

@main
struct FF6600App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            // ContentView()
            Homepage()
        }
        .modelContainer(sharedModelContainer)
    }
}

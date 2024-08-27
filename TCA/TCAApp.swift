//
//  TCAApp.swift
//  TCA
//
//  Created by Keith Lander on 26/08/2024.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct TCAApp: App {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let storeURL = URL.documentsDirectory.appending(path: "database.sqlite")
        let modelConfiguration = ModelConfiguration("WriteConfiguration", schema: schema,
            url: storeURL, cloudKitDatabase: .private("iCloud.appworks.tcademo"))
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: ContentFeature.State(context: TCAApp.sharedModelContainer.mainContext)) {
                ContentFeature()
            })
        }
        .modelContainer(TCAApp.sharedModelContainer)
    }
}

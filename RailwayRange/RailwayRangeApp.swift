//
//  RailwayRangeApp.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 14/11/2023.
//

import SwiftUI
import SwiftData

@main
struct RailwayRangeApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Station.self, Keyword.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(container: sharedModelContainer, railwayDataProvider: RailwayDataProvider())
        }
        //        .modelContainer(for: [ Station.self, StationKeyword.self ])
        .modelContainer(sharedModelContainer)
    }
}

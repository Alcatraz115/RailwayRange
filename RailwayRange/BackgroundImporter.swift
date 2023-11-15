//
//  BackgroundImporter.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 15/11/2023.
//

import Foundation
import SwiftData

actor BackgroundImporter {
    var modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func backgroundInsert<T: PersistentModel>(data: [T]) async throws {
        let modelContext = ModelContext(modelContainer)

        let batchSize = 1000
        let totalObjects = data.count

        for i in 0...(totalObjects / batchSize) {
            for j in 0..<batchSize {
                let index = i * batchSize + j
                if index < totalObjects {
                    let item = data[index]
                    modelContext.insert(item)
                }
            }

            try modelContext.save()
        }
    }
}


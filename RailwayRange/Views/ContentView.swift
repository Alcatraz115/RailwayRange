//
//  StationDistanceView.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 14/11/2023.
//

import SwiftUI
import CoreLocation
import SwiftData

struct ContentView: View {
    @AppStorage("lastFetched") private var lastFetched: Double = Date.now.timeIntervalSince1970
    @Environment(\.modelContext) private var modelContext
    
    
    @Query private var stations: [Station]
    @Query private var keywords: [Keyword]
    
    @State private var backgroundImporter: BackgroundImporter
    @State var firstSelectedStation: Station?
    @State var secondSelectedStation: Station?
    @State var isLoading = false
    
    let railwayDataProvider: RailwayDataProviding
    
    var body: some View {
        NavigationStack(){
            VStack{
                Text(firstSelectedStation?.name ?? "Brak Z")
                NavigationLink(
                    destination: StationPickerView(
                        selectedStation: $firstSelectedStation,
                        stationKeywords: keywords,
                        stations: stations
                    ),
                    label: {
                        Text("Wybierz Z")
                    })
                Text(secondSelectedStation?.name ?? "Brak DO")
                NavigationLink(
                    destination: StationPickerView(
                        selectedStation: $secondSelectedStation,
                        stationKeywords: keywords,
                        stations: stations
                    ),
                    label: {
                        Text("Wybierz DO")
                    })
                Spacer()
                
                if distance != nil {
                    Text("Odległość wynosi: \(distance ?? -1.0) m")
                }
                
                Spacer()
                Text("Ładowanie: \(isLoading ? "Tak" : "Nie")")
                HStack{
                    Spacer()
                    Button("TMP1") {
                        Task {
                            try await fetchData()
                        }
                    }
                    Spacer()
                    Button("TMP Print") {
                        tmpDebug("X")
                    }
                    Spacer()
                }
            }
            .navigationTitle("Odległość")
            .task {
                do {
                    isLoading = true
                    defer { isLoading = false }
                    
                    if hasDataExpired || hasData {
                        try clearCache()
                        try await fetchData()
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    init(container: ModelContainer, railwayDataProvider: RailwayDataProviding) {
        let backgroundImporter = BackgroundImporter(modelContainer: container)
        _backgroundImporter = State(initialValue: backgroundImporter)
        self.railwayDataProvider = railwayDataProvider
    }
}

//#Preview {
//    StationDistanceView( railwayDataProvider: RailwayDataProvider())
//        .modelContainer(for: [Station.self, StationKeyword.self])
//}

extension ContentView {
    
    private var distance:Double? {
        guard let firstLatitude = firstSelectedStation?.latitude,
              let firstLongitude = firstSelectedStation?.longitude,
              let secondLatitude = secondSelectedStation?.latitude,
              let secondLongitude = secondSelectedStation?.longitude
        else {
            return nil
        }
        
        let firstCoordinate = CLLocation(latitude: firstLatitude, longitude: firstLongitude)
        let secondCoordinate = CLLocation(latitude: secondLatitude, longitude: secondLongitude)
        
        return firstCoordinate.distance(from: secondCoordinate)
    }
    
    private var hasData:Bool {
        return stations.isEmpty || keywords.isEmpty
    }
    
    private var hasDataExpired: Bool {
        let timeLimit = 300 // 5 mins
        let currentTime = Date.now
        let lastFetchedTime = Date(timeIntervalSince1970: lastFetched)
        
        guard let differenceInMins = Calendar.current.dateComponents([.second], from: lastFetchedTime, to: currentTime).second else {
            return false
        }
        return differenceInMins >= timeLimit
    }

    func tmpDebug(_ msg:String = "") {
        print("-----S\(msg)-----")
        print("lastFetched: \(lastFetched)")
        print("isExpired: \(hasDataExpired)")
        print("Sizes: \(stations.count) \(keywords.count)")
        print("-----E\(msg)-----")
    }
    
    func clearCache() throws {
        _ = try modelContext.delete(model: Station.self)
        _ = try modelContext.delete(model: Keyword.self)
    }
    
    private func fetchData() async throws{
        let fetchedKeywords = try await railwayDataProvider.fetchKeywords()
        let fetchedStations = try await railwayDataProvider.fetchStations()
        
        try await backgroundImporter.backgroundInsert(data: fetchedKeywords)
        try await backgroundImporter.backgroundInsert(data: fetchedStations)
        
        lastFetched = Date.now.timeIntervalSince1970
    }
}

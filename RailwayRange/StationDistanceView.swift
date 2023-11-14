//
//  StationDistanceView.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 14/11/2023.
//

import SwiftUI
import CoreLocation

struct StationDistanceView: View {
    @StateObject private var viewModel = StationDistanceViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            VStack{
                Text(viewModel.firstSelectedStation?.name ?? "Brak Z")
                NavigationLink(
                    destination: StationPickerView(
                        selectedStation: $viewModel.firstSelectedStation,
                        stationKeywords: viewModel.stationKeywords,
                        stations: viewModel.stations
                    ),
                    label: {
                        Text("Wybierz Z")
                    })
                Text(viewModel.secondSelectedStation?.name ?? "Brak DO")
                NavigationLink(
                    destination: StationPickerView(
                        selectedStation: $viewModel.secondSelectedStation,
                        stationKeywords: viewModel.stationKeywords,
                        stations: viewModel.stations
                    ),
                    label: {
                        Text("Wybierz DO")
                    })
                Spacer()
                
                if viewModel.distance != nil {
                    Text("Odległość wynosi: \(viewModel.distance ?? -1.0) m")
                }
                
                Spacer()
                Text("Ładowanie: \(viewModel.isLoading ? "Tak" : "Nie")")
                Button("TMP", action: { viewModel.tmp2() })
            }
        }
    }
}

#Preview {
    StationDistanceView()
}

extension StationDistanceView {
    @MainActor class StationDistanceViewModel: ObservableObject {
        @Published private(set) var stationKeywords:[StationKeyword] = []
        @Published private(set) var stations:[Station] = []
        
        @Published var firstSelectedStation: Station?
        @Published var secondSelectedStation: Station?
        @Published var isLoading = false
        
        let railwayDataProvider: RailwayDataProviding = RailwayDataProvider()
        
        var distance:Double? {
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
        
        init() {
            Task.init {
                do {
                    isLoading = true
                    let value = try await railwayDataProvider.fetchKeywords()
                    stationKeywords = value
                    print(value.count)
                    let value2 = try await railwayDataProvider.fetchStations()
                    stations = value2.sorted { $0.hits > $1.hits }
                    print(value2.count)
                    isLoading = false
                } catch {
                    print("failed")
                }
            }
        }
    }
}


struct StationKeyword: Codable {
    let id: Int
    let keyword: String
    let stationId: Int
}

struct Station: Codable {
    let id: Int
    let name: String
    let nameSlug: String
    let latitude: Double?
    let longitude: Double?
    let hits: Int
    let ibnr: Int?
    let city: String
    let region: String
    let country: String
    let localizedName: String?
    let isGroup: Bool
    let hasAnnouncements: Bool
}

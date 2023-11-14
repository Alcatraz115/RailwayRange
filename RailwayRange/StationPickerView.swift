//
//  StationPickerView.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 14/11/2023.
//

import SwiftUI

struct StationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedStation: Station?
    var stationKeywords: [StationKeyword]
    var stations: [Station]
    @State var searchTerm = ""
    
    var filteredStations: [Station] {
        guard !searchTerm.isEmpty else { return stations }
        let filteredKeywords = stationKeywords.filter { $0.keyword.localizedCaseInsensitiveContains(searchTerm) }
        return stations.filter { X in filteredKeywords.contains { Y in Y.stationId == X.id } }
    }
    
    var body: some View {
        List(filteredStations, id: \.id) { station in
            Button(action: {
                selectedStation = station
                dismiss()
            }, label: {
                VStack {
                    Text(station.name)
                    Text("\(station.hits)")
                }
            })
            
        }
        .navigationTitle("Stacje")
        .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
    }
}

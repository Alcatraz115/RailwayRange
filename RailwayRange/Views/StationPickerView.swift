//
//  StationPickerView.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 14/11/2023.
//

import SwiftUI
import SwiftData

struct StationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Binding var selectedStation: Station?
    @State var searchTerm = ""
    

    var body: some View {
        StationPickerList(
            searchTerm: searchTerm,
            selectedStation: $selectedStation
        )
            .navigationTitle("Stacje")
            .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct StationPickerList: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var stations: [Station]
    @Query private var keywords: [Keyword]

    @Binding var selectedStation: Station?
    
    var body: some View {
        List(stations.prefix(20), id: \.id) { station in
            Button(action: {
                selectedStation = station
                dismiss()
            }, label: {
                VStack (alignment: .leading) {
                    Text(station.name)
                        .fontWeight(.bold)
                    HStack() {
                        Text(station.city.isEmpty ? "Brak Danych" : station.city)
                        Text(station.country.isEmpty ? "Brak Danych" : station.country)
                    }.fontWeight(.light)
                }.foregroundColor(.primary)
            })
            
        }
    }
    
    init( searchTerm: String, selectedStation: Binding<Station?>) {
        _selectedStation = selectedStation
        
//        _keywords = Query(filter: #Predicate { X in
//            if searchTerm.isEmpty {
//                return true
//            } else {
//                return X.keyword.localizedStandardContains(searchTerm)
//            }
//        })
        
        _stations = Query(filter: #Predicate { X in
            if searchTerm.isEmpty {
                return true
            } else {
//                return keywords.contains { $0.stationId == X.id }
                return X.name.localizedStandardContains(searchTerm)
            }
        }, sort: \Station.hits, order: .reverse)
    }
    
}


//
//  RailwayDataProvider.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 14/11/2023.
//

import Foundation

protocol RailwayDataProviding {
    func fetchStations() async throws -> [Station]
    
    func fetchKeywords() async throws -> [Keyword]
}

struct RailwayDataProvider: RailwayDataProviding {
    func fetchStations() async throws -> [Station] {
        let url = URL(string: "https://koleo.pl/api/v2/main/stations")
        
        var request = URLRequest(url: url!)
        request.addValue("1", forHTTPHeaderField: "X-KOLEO-Version")
        request.addValue("iOS-100", forHTTPHeaderField: "X-KOLEO-Client")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode([Station].self, from: data)
        
    }
    
    func fetchKeywords() async throws -> [Keyword] {
        let url = URL(string: "https://koleo.pl/api/v2/main/station_keywords")
        
        var request = URLRequest(url: url!)
        request.addValue("1", forHTTPHeaderField: "X-KOLEO-Version")
        request.addValue("iOS-100", forHTTPHeaderField: "X-KOLEO-Client")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode([Keyword].self, from: data)
    }
}

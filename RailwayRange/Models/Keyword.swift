//
//  Keyword.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 15/11/2023.
//

import Foundation
import SwiftData

@Model
class Keyword: Codable {
    @Attribute(.unique)
    let id: Int
    
    let keyword: String
    let stationId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case keyword
        case stationId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.keyword = try container.decode(String.self, forKey: .keyword)
        self.stationId = try container.decode(Int.self, forKey: .stationId)
    }
    
    func encode(to encoder: Encoder) throws {
        //TODO: Handle encoding if you need to here
    }
}


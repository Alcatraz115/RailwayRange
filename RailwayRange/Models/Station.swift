//
//  Stations.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 14/11/2023.
//

import Foundation
import SwiftData

@Model
class Station: Codable {
    @Attribute(.unique)
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
//    let localizedName: String?
    let isGroup: Bool
    let hasAnnouncements: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nameSlug
        case latitude
        case longitude
        case hits
        case ibnr
        case city
        case region
        case country
//        case localizedName
        case isGroup
        case hasAnnouncements
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSlug = try container.decode(String.self, forKey: .nameSlug)
        self.latitude = try container.decode(Double?.self, forKey: .latitude)
        self.longitude = try container.decode(Double?.self, forKey: .longitude)
        self.hits = try container.decode(Int.self, forKey: .hits)
        self.ibnr = try container.decode(Int?.self, forKey: .ibnr)
        self.city = try container.decode(String.self, forKey: .city)
        self.region = try container.decode(String.self, forKey: .region)
        self.country = try container.decode(String.self, forKey: .country)
//        self.localizedName = try container.decode(String?.self, forKey: .localizedName)
        self.isGroup = try container.decode(Bool.self, forKey: .isGroup)
        self.hasAnnouncements = try container.decode(Bool.self, forKey: .hasAnnouncements)
       
    }
    
    func encode(to encoder: Encoder) throws {
        //TODO: Handle encoding if you need to here
    }
}

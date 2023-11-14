//
//  Item.swift
//  RailwayRange
//
//  Created by Damian Skarżyński on 14/11/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

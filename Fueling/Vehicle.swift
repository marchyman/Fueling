//
//  Vehicle.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/5/23.
//

import Foundation
import SwiftData

@Model
final class Vehicle {
    @Attribute(.unique)
    var name: String
    var initialTimestamp: Date
    var odometer: Int

    init(name: String, odometer: Int) {
        self.name = name
        initialTimestamp = Date()
        self.odometer = odometer
    }
}

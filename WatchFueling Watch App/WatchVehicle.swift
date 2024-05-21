//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import Foundation

struct Vehicle: Identifiable, Sendable {
    let name: String
    let cost: Double
    let gallons: Double
    let miles: Int

    var id: String { name }
    var mpg: Double { gallons == 0 ? 0 : Double(miles) / gallons }
    var cpg: Double { gallons == 0 ? 0 : cost / gallons }
}

extension Vehicle{
    static let previewVehicle = Vehicle(name: "Test Vehicle",
                                        cost: 123.76,
                                        gallons: 22.583,
                                        miles: 1185)
    enum VehicleModelError: Error {
        case badPlist
    }

    // build a vehicle model from a property list entry in this format:
    // [<vehicle name>: ["Cost": Double, "Gallons": Double, "Miles": Int]]
    init(from key: String, value: Any) throws  {
        if let dict = value as? [String: Any] {
            self.name = key
            self.cost = dict[MessageKey.cost] as? Double ?? 0.0
            self.gallons = dict[MessageKey.gallons] as? Double ?? 0.0
            self.miles = dict[MessageKey.miles] as? Int ?? 0
        } else {
            throw VehicleModelError.badPlist
        }
    }
}

// compare on vehicle name for sorting
extension Vehicle: Comparable {
    static func < (lhs: Vehicle, rhs: Vehicle) -> Bool {
        lhs.name < rhs.name
    }
}

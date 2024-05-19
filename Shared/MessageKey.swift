//
//  MessageKey.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/18/24.
//

import Foundation

// Messages between watch and phone are in the form of property lists.
// The watch makes requests and the phone response with appropriate data.
// The message tranfsfers are:
//
// 1: Request list of known vehicles
// - watch sends:
//   ["get": "vehicles"]
// - phone replies:
//   ["vehicle": [String]]
//   [String] is an array of vehicle names.  The array may be empty.
//
// 2: Request statistics for a vehicle by name
// - watch sends:
//   ["vehicle": String]
//   String is a vehicle name
// - phone replies:
//   [String : Dictionary]
//   String: The name of a vehicle
//   Dictionary contains of the following entries
//      ["Cost" : Double
//       "Gallons" : Double,
//       "Miles" : Int]
//
//   if the vehicle name is unknown the reply is:
//   [String : "not found"]


enum MessageKey {
    static let get = "get"
    static let vehicles = "vehicles"
    static let vehicle = "vehicle"
    static let cost = "Cost"
    static let gallons = "Gallons"
    static let miles = "Miles"
    static let notFound = "not found"
}

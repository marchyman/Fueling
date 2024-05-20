//
//  MessageKey.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/18/24.
//

import Foundation

/*

Messages between watch and phone are in the form of property lists. The
keys for the various properties are defined here.

Version 2 data flow
===================

- The phone will send an application context consisting of the names of known
  vehicles and fueling statistics about the vehicle at startup and whenever
  the data changes.  The format of the context is:

    [[String: Dictionary]]

  where String is the name of the vehicle and the dictionary contains the
  fueling statistics.  An entry therefore looks like this:

    [<vehicle name>: ["cost": Double, "gallons": Double, "miles": Int]]

- The watch can request an application context update by sending this message:

    ["get", "vehicles"]

  no message reply is expected. The phone will initiate an application context
  update.

- The watch sends fueling updates to the copanion application on the phone
  using this format:

    ["put", Dictionary]

 The dictionary contains the following values

    ["vehicle" : String,
     "cost" : Double
     "gallons" : Double,
     "miles" : Int]

  The phone companion app will respond with one of the following:

    ["put": "updated"]
    ["put": "some error message in the form of a string" ]

*/

enum MessageKey {
    static let get = "get"
    static let put = "put"
    static let vehicles = "vehicles"
    static let vehicle = "vehicle"
    static let cost = "cost"
    static let gallons = "gallons"
    static let miles = "miles"
    static let updated = "updated"
}

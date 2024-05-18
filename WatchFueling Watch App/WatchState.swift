//
//  WatchState.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/17/24.
//

import Foundation
import OSLog
import SwiftUI

extension Logger: @unchecked Sendable {}

@Observable
final class WatchState: @unchecked Sendable  {
    nonisolated static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                        category: "WatchState")
    var vehicles: [String] = []
    var ws = WatchSession()

    // data fetched when a vehicle is selected
    var fetching = false
    var name: String = ""
    var cost: Double = 0
    var gallons: Double = 0
    var miles: Int = 0
    var mpg: Double {
        gallons == 0 ? 0 : Double(miles) / gallons
    }
    var cpg: Double {
        gallons == 0 ? 0 : cost / gallons
    }

    init() {
        //
    }
}

// fetch data from companion app
extension WatchState {
    
    // fetch the list of vehicle names
    func getVehicles() {
        if ws.session.isReachable {
            Self.log.debug("get vehicles")
            ws.session.sendMessage([MessageKey.get: MessageKey.vehicles],
                                   replyHandler: gotVehicles,
                                   errorHandler: errorHandler)
        }
    }

    func gotVehicles(_ response: [String : Any]) {
        WatchSession.log.notice("Got Vehicles:")
        for (key, value) in response where key == MessageKey.vehicles {
            Self.log.debug("vehicles key")
            if let allVehicles = value as? [String] {
                Task { @MainActor in
                    vehicles = allVehicles
                    Self.log.debug("vehicles: \(self.vehicles.debugDescription)")
                }
            } else {
                Self.log.debug("vehicles not set")
            }
        }
    }

    // Fetch statistics for a specific vehicle
    func getVehicle(named vehicle: String) {
        Self.log.debug("vehicle \(vehicle, privacy: .public)")
        if ws.session.isReachable {
            fetching = true
            name = vehicle
            ws.session.sendMessage([MessageKey.vehicle: vehicle],
                                   replyHandler: gotVehicle,
                                   errorHandler: errorHandler)
        }
    }

    func gotVehicle(_ response: [String: Any]) {
        Self.log.debug("Got Vehicle")
        Self.log.debug("\(response, privacy: .public)")
        if let dict = response[name] as? [String: Any] {
            cost = dict[MessageKey.cost] as? Double ?? 0.0
            gallons = dict[MessageKey.gallons] as? Double ?? 0.0
            miles = dict[MessageKey.miles] as? Int ?? 0
        } else {
            cost = 0
            gallons = 0
            miles = 0
        }
        fetching = false
    }

    func errorHandler(error: any Error) {
        Self.log.error("error: \(error.localizedDescription)")
    }
}

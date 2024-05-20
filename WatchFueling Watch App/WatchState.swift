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

// fetch/update data from/to companion app
extension WatchState {
    
    // fetch the list of vehicle names
    // extra debug on this request as it is the first used to send a request
    // for data to the companion app on the phone.
    func getVehicles() {
        guard ws.session.activationState == .activated else {
            Self.log.debug("\(#function) session not activated")
            return
        }
        guard ws.session.isCompanionAppInstalled else {
            Self.log.debug("\(#function) companion app not installed")
            return
        }
        guard ws.session.isReachable else {
            Self.log.debug("\(#function) session not reachable")
            return
        }
        fetching = true
        ws.session.sendMessage([MessageKey.get: MessageKey.vehicles],
                               replyHandler: gotVehicles,
                               errorHandler: errorHandler)
    }

    func gotVehicles(_ response: [String : Any]) {
        Self.log.debug("\(#function) \(response, privacy: .public)")
        if let allVehicles = response[MessageKey.vehicles] as? [String] {
            Task { @MainActor in
                vehicles = allVehicles
                fetching = false
            }
        } else {
            Task { @MainActor in fetching = false }
        }
    }

    // Fetch statistics for a specific vehicle
    func getVehicle(named vehicle: String) {
        guard ws.session.isReachable else {
            Self.log.debug("\(#function) session not reachable")
            return
        }
        Self.log.notice("\(#function) \(vehicle, privacy: .public)")
        fetching = true
        name = vehicle
        ws.session.sendMessage([MessageKey.vehicle: vehicle],
                               replyHandler: gotVehicle,
                               errorHandler: errorHandler)
    }

    func gotVehicle(_ response: [String: Any]) {
        Self.log.notice("\(#function) \(response, privacy: .public)")
        if let dict = response[name] as? [String: Any] {
            let cost = dict[MessageKey.cost] as? Double ?? 0.0
            let gallons = dict[MessageKey.gallons] as? Double ?? 0.0
            let miles = dict[MessageKey.miles] as? Int ?? 0
            Task { @MainActor in
                self.cost = cost
                self.gallons = gallons
                self.miles = miles
                fetching = false
            }
        } else {
            Task { @MainActor in
                cost = 0
                gallons = 0
                miles = 0
                fetching = false
            }
        }
    }

    func putFueling(vehicle: String,
                    cost: Double,
                    gallons: Double,
                    miles: Double) {
        if ws.session.isReachable {
            Self.log.debug("\(#function) \(vehicle, privacy: .public)")
            var plist: [String: Any] = [:]
            plist[MessageKey.vehicle] = vehicle
            plist[MessageKey.cost] = cost
            plist[MessageKey.gallons] = gallons
            plist[MessageKey.miles] = Int(miles)
            fetching = true
            name = vehicle
            ws.session.sendMessage([MessageKey.put: plist],
                                   replyHandler: gotVehicle,
                                   errorHandler: errorHandler)
        }

    }

    func errorHandler(error: any Error) {
        Self.log.error("\(#function) \(error.localizedDescription)")
    }
}

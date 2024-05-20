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

@MainActor
@Observable
final class WatchState {
    nonisolated static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                        category: "WatchState")
    var vehicles: [Vehicle] = []
    var ws: WatchSession!

    // data fetched when a vehicle is selected
    var fetching = false

    init() {
        ws = WatchSession(state: self)
    }
}

extension WatchState {
    
    // update the vehicles arrayx.
    func update(vehicle: Vehicle) {
        if let index = vehicles.firstIndex(where: { $0.name == vehicle.name }) {
            vehicles[index] = vehicle
        } else {
            vehicles.append(vehicle)
        }
    }

    // Request vehicle data.  This will trigger an application context update
    // when received by the companion app on the phone.
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
                               replyHandler: nil,
                               errorHandler: errorHandler)
    }

    // Send fueling data to the companion app on the phone.
    func putFueling(vehicle: Vehicle,
                    cost: Double,
                    gallons: Double,
                    miles: Double) {
        if ws.session.isReachable {
            Self.log.debug("\(#function) \(vehicle.name, privacy: .public)")
            var plist: [String: Any] = [:]
            plist[MessageKey.vehicle] = vehicle.name
            plist[MessageKey.cost] = cost
            plist[MessageKey.gallons] = gallons
            plist[MessageKey.miles] = Int(miles)
            fetching = true
            ws.session.sendMessage([MessageKey.put: plist],
                                   replyHandler: putStatus,
                                   errorHandler: errorHandler)
        }
    }

    func putStatus(_ response: [String: Any]) {
        Self.log.debug("\(#function) \(response, privacy: .public)")
        fetching = false
        let value = response[MessageKey.put] as? String ?? "Bad response"
        if value != MessageKey.updated {
            Self.log.error("\(#function) \(value, privacy: .public)")
        }
    }

    func errorHandler(error: any Error) {
        Self.log.error("\(#function) \(error.localizedDescription)")
    }
}

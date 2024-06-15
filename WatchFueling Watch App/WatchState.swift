//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import Foundation
import OSLog
import SwiftUI

@MainActor
@Observable
final class WatchState {
    var vehicles: [Vehicle] = []
    private var ws: WatchSession!

    // data fetched when a vehicle is selected
    var fetching = false

    init() {
        ws = WatchSession(state: self)
    }
}

extension WatchState {
    // logging
    nonisolated static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                        category: "WatchState")
}

extension WatchState {
    
    // update the vehicles array.
    func update(vehicle: Vehicle) {
        if let index = vehicles.firstIndex(where: { $0.name == vehicle.name }) {
            vehicles[index] = vehicle
        } else {
            vehicles.append(vehicle)
        }
    }

    // Request vehicle data.  This will trigger an application context update
    // when received by the companion app on the phone.
    @discardableResult
    func getVehicles() -> Bool {
        guard ws.session.activationState == .activated else {
            Self.log.debug("\(#function) session not activated")
            return false
        }
        guard ws.session.isCompanionAppInstalled else {
            Self.log.debug("\(#function) companion app not installed")
            return false
        }
        guard ws.session.isReachable else {
            Self.log.debug("\(#function) session not reachable")
            return false
        }
        ws.session.sendMessage([MessageKey.get: MessageKey.vehicles],
                               replyHandler: nil,
                               errorHandler: errorHandler)
        Self.log.debug("\(#function) Sent get vehicles ")
        return true
    }

    // Send fueling data to the companion app on the phone.
    func putFueling(vehicle: Vehicle,
                    cost: Double,
                    gallons: Double,
                    odometer: Double) {
        if ws.session.isReachable {
            Self.log.debug("\(#function) \(vehicle.name, privacy: .public)")
            var plist: [String: Any] = [:]
            plist[MessageKey.vehicle] = vehicle.name
            plist[MessageKey.cost] = cost
            plist[MessageKey.gallons] = gallons
            plist[MessageKey.miles] = Int(odometer)
            fetching = true
            ws.session.sendMessage([MessageKey.put: plist],
                                   replyHandler: putStatus,
                                   errorHandler: errorHandler)
        }
    }

    nonisolated
    func putStatus(_ response: [String: Any]) {
        Self.log.debug("\(#function) \(response, privacy: .public)")
        Task { @MainActor in
            fetching = false
        }
        let value = response[MessageKey.put] as? String ?? "Bad response"
        if value != MessageKey.received {
            Self.log.error("\(#function) \(value, privacy: .public)")
        }
    }

    nonisolated
    func errorHandler(error: any Error) {
        Self.log.error("\(#function) \(error.localizedDescription)")
    }
}

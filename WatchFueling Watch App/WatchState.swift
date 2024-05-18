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
final class WatchState {
    nonisolated static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                        category: "WatchState")
    var vehicles: [String] = []
    var ws = WatchSession()

    init() {
        //
    }
}

extension WatchState {
    func getVehicles() {
        if ws.session.isReachable {
            ws.session.sendMessage(["get": "vehicles"],
                                   replyHandler: gotVehicles,
                                   errorHandler: errorHandler)
        }
    }

    func gotVehicles(_ response: [String : Any]) {
        WatchSession.log.notice("Rcvd response:")
        for (key, value) in response where key == "vehicles" {
            Self.log.debug("vehicles key")
            if let allVehicles = value as? [String] {
                vehicles = allVehicles
                Self.log.debug("vehicles: \(self.vehicles.debugDescription)")
            } else {
                Self.log.debug("vehicles not set")
            }
        }
    }

    func errorHandler(error: any Error) {
        Self.log.error("error: \(error.localizedDescription)")
    }
}

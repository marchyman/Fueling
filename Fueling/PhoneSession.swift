//
//  PhoneSession.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/2/24.
//

import Foundation
import OSLog
import WatchConnectivity

final class PhoneSession: NSObject {
    let state: FuelingState

    static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                            category: "PhoneSession")
    let session: WCSession = .default

    init(state: FuelingState) {
        self.state = state
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            Self.log.notice("Session not supported")
        }
    }
}

extension PhoneSession {
    // build and return a plist of stats for a vehicle by name
    func getStats(for vehicle: Vehicle) -> [String: Any] {
        var plist: [String: Any] = [:]
        plist[MessageKey.cost] = vehicle.fuelCost
        plist[MessageKey.gallons] = vehicle.fuelUsed
        plist[MessageKey.miles] = vehicle.milesDriven
        return plist
    }
}

extension PhoneSession: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: (any Error)?) {
        Self.log.notice("activationDidCompleteWith \(activationState.rawValue)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        Self.log.notice("session inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        Self.log.notice("session deactivated")
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String: Any],
                 replyHandler: @escaping ([String: Any]) -> Void) {
        Self.log.notice("didReceiveMessage: \(message.debugDescription, privacy: .public)")
        if message[MessageKey.get] as? String == MessageKey.vehicles {
            replyHandler([MessageKey.vehicles : state.vehicles.map { $0.name }])
        } else if let name = message[MessageKey.vehicle] as? String {
            if let vehicle = state.vehicles.first(where: { $0.name == name }) {
                replyHandler([name: getStats(for: vehicle)])
            } else {
                replyHandler([name: MessageKey.notFound])
            }
        } else if let dict = message[MessageKey.put] as? [String: Any],
                  let name = dict[MessageKey.vehicle] as? String {
            let cost = dict[MessageKey.cost] as? Double
            let gallons = dict[MessageKey.gallons] as? Double
            let miles = dict[MessageKey.miles] as? Int
            if let cost, let gallons, let miles,
               let vehicle = state.vehicles.first(where: { $0.name == name }) {
                state.addFuel(vehicle: vehicle, fuel: Fuel(odometer: miles,
                                                           amount: gallons,
                                                           cost: cost))
                replyHandler([name: getStats(for: vehicle)])
            } else {
                replyHandler([name: MessageKey.notFound])
            }

        } else {
            Self.log.error("Unknown message: \(message, privacy: .public)")
            replyHandler(["request": MessageKey.notFound])
        }
    }
}

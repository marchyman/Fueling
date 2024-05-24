//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import Foundation
import OSLog
@preconcurrency import WatchConnectivity

final class PhoneSession: NSObject, @unchecked Sendable {
    unowned let state: FuelingState
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
    // logging
    static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                            category: "PhoneSession")
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

    // receive a message that does not require a reply
    func session(_ session: WCSession,
                 didReceiveMessage message: [String: Any]) {
        Self.log.notice("\(#function) \(message.debugDescription, privacy: .public)")
        if message[MessageKey.get] as? String == MessageKey.vehicles {
            Task {
                await state.sendAppContext()
            }
        } else {
            Self.log.error("\(#function) unknown message")
        }
    }

    // receive a message that requires a reply
    func session(_ session: WCSession,
                 didReceiveMessage message: [String: Any],
                 replyHandler: @escaping @Sendable ([String: Any]) -> Void) {
        Self.log.notice("\(#function) \(message.debugDescription, privacy: .public)")
        if let dict = message[MessageKey.put] as? [String: Any],
                  let name = dict[MessageKey.vehicle] as? String {
            let cost = dict[MessageKey.cost] as? Double
            let gallons = dict[MessageKey.gallons] as? Double
            let odometer = dict[MessageKey.miles] as? Int
            if let cost, let gallons, let odometer {
                Task {
                    let response = await state.addFuel(name: name, cost: cost,
                                                       gallons: gallons,
                                                       odometer: odometer)
                    replyHandler([MessageKey.put: response])
                }
            } else {
                replyHandler([MessageKey.put: ""])
            }

        } else {
            Self.log.error("Unknown message: \(message, privacy: .public)")
            replyHandler(["unknown": "request"])
        }
    }
}

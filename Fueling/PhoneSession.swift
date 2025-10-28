//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import Foundation
import OSLog
import UDF
import WatchConnectivity

@MainActor
final class PhoneSession: NSObject {
    let session: WCSession = .default
    unowned let store: Store<FuelingState, FuelingEvent>

    init(store: Store<FuelingState, FuelingEvent>) {
        self.store = store
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            Logger(subsystem: "org.snafu", category: "PhoneSession")
                .notice("Session not supported")
        }
    }
}

// Messages sent to the watch component

extension PhoneSession {

    // send the current app state (vehicle name and stats) to the watch
    // as an application context message.  Lots of checks here as this
    // is the first communications sent by the phone and I'd like to
    // see the debug messages if things fail when testing.
    @discardableResult
    func sendAppContext() -> Bool {
        let logger = Logger(subsystem: "org.snafu", category: "FuelingState")
        let context = store.state.appContext()
        guard session.activationState == .activated else {
            logger.debug("\(#function) session not activated")
            return false
        }
        guard session.isWatchAppInstalled else {
            logger.debug("\(#function) companion app not installed")
            return false
        }
        guard session.isReachable else {
            logger.debug("\(#function) session not reachable")
            return false
        }
        logger.debug("\(#function) \(context, privacy: .public)")
        do {
            try session.updateApplicationContext(context)
            return true
        } catch {
            logger.error("\(#function) \(error.localizedDescription, privacy: .public)")
        }
        return false
    }
}

// WCSessionDelegate functions

extension PhoneSession: WCSessionDelegate {
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
            .notice("activationDidCompleteWith \(activationState.rawValue)")
        if activationState == .activated {
            Task { @MainActor in
                store.send(.phoneSessionActivated(self))
            }
        }
    }

    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {
        Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
            .notice("session inactive")
    }

    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
            .notice("session deactivated")
    }

    // phone/watch app reachability changed.

    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
            .debug("\(#function) \(session.isReachable, privacy: .public)")

        if session.isReachable {
            Task { @MainActor in
                sendAppContext()
            }
        }
    }

    // receive a message that does not require a reply
    nonisolated func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
            .notice("\(#function) \(message.debugDescription, privacy: .public)")
        if message[MessageKey.get] as? String == MessageKey.vehicles {
            Task { @MainActor in
                sendAppContext()
            }
        } else {
            Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
                .error("\(#function) unknown message")
        }
    }

    // receive a message that requires a reply
    nonisolated func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
            .notice("\(#function) \(message.debugDescription, privacy: .public)")
        if let dict = message[MessageKey.put] as? [String: Any],
            let name = dict[MessageKey.vehicle] as? String
        {
            let cost = dict[MessageKey.cost] as? Double
            let gallons = dict[MessageKey.gallons] as? Double
            let odometer = dict[MessageKey.miles] as? Int
            if let cost, let gallons, let odometer {
                let fuelData = FuelData(odometer: odometer,
                                        amount: gallons,
                                        cost: cost)
                Task { [store] in
                    await MainActor.run {
                        store.send(.addFuelReceived(name, fuelData))
                    }
                }
                replyHandler([MessageKey.put: MessageKey.received])
            } else {
                replyHandler([MessageKey.put: ""])
            }

        } else {
            Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
                .error("Unknown message: \(message, privacy: .public)")
            replyHandler(["unknown": "request"])
        }
    }
}

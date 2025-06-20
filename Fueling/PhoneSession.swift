//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import Foundation
import OSLog
import UDF
@preconcurrency import WatchConnectivity

@MainActor
final class PhoneSession: NSObject {
    let session: WCSession = .default
    let store: Store<FuelingState, FuelingAction>

    init(store: Store<FuelingState, FuelingAction>) {
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

    // send the current app state (vehicle name and stats) to the watch
    // as an application context message.  Lots of checks here as this
    // is the first communications sent by the phone and I'd like to
    // see the debug messages if things fail when testing.
    @discardableResult
    func sendAppContext(appContext: [String: Any]) -> Bool {
        let logger = Logger(subsystem: "org.snafu", category: "FuelingState")

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
        logger.debug("\(#function) \(appContext, privacy: .public)")
        do {
            try session.updateApplicationContext(appContext)
            return true
        } catch {
            logger.error("\(#function) \(error.localizedDescription, privacy: .public)")
        }
        return false
    }

    // Wait a second for the phone session to be activated and the watch
    // to become reachable before sending the initial app context message.
    // retry every second until the message is sent. Cap the number of
    // retries -- the watch app may not be installed.
    func sendInitialAppContext(appContext: [String: Any]) {
        Task(priority: .background) {
            for _ in 0 ... 9 {
                try? await Task.sleep(for: .seconds(1))
                if sendAppContext(appContext: appContext) {
                    break
                }
            }
        }
    }
}

extension PhoneSession: WCSessionDelegate {
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
            .notice("activationDidCompleteWith \(activationState.rawValue)")
    }

    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {
        Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
            .notice("session inactive")
    }

    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        Logger(subsystem: "org.snafu", category: "PhoneSessionDelegate")
            .notice("session deactivated")
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
                let context = store.state.appContext()
                sendAppContext(appContext: context)
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
                let fuelData = FuelingState.FuelData(name: name,
                                                     cost: cost,
                                                     gallons: gallons,
                                                     odometer: odometer)
                Task { [store] in
                    await MainActor.run {
                        store.send(.addFuelReceived(fuelData))
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

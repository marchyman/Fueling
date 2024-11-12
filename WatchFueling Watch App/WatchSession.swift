//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import Foundation
import OSLog
import WatchConnectivity

final class WatchSession: NSObject {
    unowned let state: WatchState
    let session: WCSession = .default

    init(state: WatchState) {
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

extension WatchSession {
    // logging
    static let log = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "WatchSession")
}

extension WatchSession: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        Self.log.notice("\(#function) \(activationState.rawValue)")
    }

    // the only data the watch expects to recieve that isn't a response to
    // message sent is an application context update. Process that here.
    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        var vehicles: [Vehicle] = []

        Self.log.notice(
            "\(#function) \(applicationContext.debugDescription, privacy: .public)")
        for (key, value) in applicationContext {
            do {
                let vehicle = try Vehicle(from: key, value: value)
                vehicles.append(vehicle)
            } catch {
                Self.log.error(
                    "\(#function) \(error.localizedDescription, privacy: .public)")
            }
        }
        let sortedVehicles = vehicles.sorted()
        Task { [state] in
            await MainActor.run {
                state.vehicles = sortedVehicles
                state.fetching = false
                state.vehiclesChanged.toggle()
            }
        }
    }
}

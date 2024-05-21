//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import Foundation
import OSLog
import WatchConnectivity

final class WatchSession: NSObject, @unchecked Sendable  {
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
    nonisolated static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                        category: "WatchSession")
}

extension WatchSession: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: (any Error)?) {
        Self.log.notice("activationDidCompleteWith \(activationState.rawValue)")
    }

    func session(_ session: WCSession,
                 didReceiveApplicationContext applicationContext: [String : Any] ) {
        var vehicles: [Vehicle] = []

        Self.log.notice("didReceivedApplicationContext: \(applicationContext.debugDescription, privacy: .public)")
        for (key, value) in applicationContext {
            do {
                let vehicle = try Vehicle(from: key, value: value)
                vehicles.append(vehicle)
            } catch {
                Self.log.error("\(#function) \(error.localizedDescription, privacy: .public)")
            }
        }
        let sortedVehicles = vehicles.sorted()
        Task { @MainActor in
            state.vehicles = sortedVehicles
            state.fetching = false
        }
    }

//    func session(_ session: WCSession,
//                 didReceiveMessage message: [String : Any]) {
//        Self.log.notice("didReceiveMessage: \(message.debugDescription, privacy: .public)")
//    }
//
//    func session(_ session: WCSession,
//                 didReceiveMessage message: [String : Any],
//                 replyHandler: ([String: Any]) -> Void) {
//        Self.log.notice("didReceiveMessage:replyHandler: \(message.debugDescription, privacy: .public)")
//    }
//    
//    func session(_ session: WCSession,
//                 didReceiveMessageData messageData: Data) {
//        Self.log.notice("didReceiveMessageData: \(messageData.debugDescription, privacy: .public)")
//    }
//
//    func session(_ session: WCSession,
//                 didReceiveMessageData messageData: Data,
//                 replyHandler: (Data) -> Void) {
//        Self.log.notice("didReceiveMessageData:replyHandler: \(messageData.debugDescription, privacy: .public)")
//    }
}

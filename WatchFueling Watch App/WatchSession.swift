//
//  WatchSession.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/2/24.
//

import Foundation
import OSLog
import WatchConnectivity

extension Logger: @unchecked Sendable {}

final class WatchSession: NSObject  {
    static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                            category: "WatchSession")
    let session: WCSession = .default

    var isReachable: Bool {
        session.isReachable
    }

    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            Self.log.notice("Session not supported")
        }
    }
}

extension WatchSession: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: (any Error)?) {
        Self.log.notice("activationDidCompleteWith \(activationState.rawValue)")
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any]) {
        Self.log.notice("didReceiveMessage: \(message.debugDescription, privacy: .public)")
    }

}

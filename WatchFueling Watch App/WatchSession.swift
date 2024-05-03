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

    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
}

extension WatchSession: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: (any Error)?) {
        Self.log.notice("activationDidCompleteWith \(activationState.rawValue)")
    }
}

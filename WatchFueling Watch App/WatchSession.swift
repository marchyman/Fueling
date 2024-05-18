//
//  WatchSession.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/2/24.
//

import Foundation
import OSLog
import WatchConnectivity

final class WatchSession: NSObject  {
    nonisolated static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
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
                 didReceiveApplicationContext applicationContext: [String : Any] ) {
        Self.log.notice("didReceivedApplicationContext: \(applicationContext.debugDescription, privacy: .public)")
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any]) {
        Self.log.notice("didReceiveMessage: \(message.debugDescription, privacy: .public)")
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any],
                 replyHandler: ([String: Any]) -> Void) {
        Self.log.notice("didReceiveMessage:replyHandler: \(message.debugDescription, privacy: .public)")
    }
    
    func session(_ session: WCSession,
                 didReceiveMessageData messageData: Data) {
        Self.log.notice("didReceiveMessageData: \(messageData.debugDescription, privacy: .public)")
    }

    func session(_ session: WCSession,
                 didReceiveMessageData messageData: Data,
                 replyHandler: (Data) -> Void) {
        Self.log.notice("didReceiveMessageData:replyHandler: \(messageData.debugDescription, privacy: .public)")
    }
}

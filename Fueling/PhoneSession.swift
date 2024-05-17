//
//  PhoneSession.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/2/24.
//

import Foundation
import OSLog
import WatchConnectivity

extension Logger: @unchecked Sendable {}

final class PhoneSession: NSObject  {
    static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                            category: "PhoneSession")
    let session: WCSession = .default
    var vehicles: [Vehicle] = []

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
                 didReceiveMessage message: [String : Any],
                 replyHandler: @escaping ([String: Any]) -> Void) {
        Self.log.notice("didReceiveMessage: \(message.debugDescription, privacy: .public)")
        for (key, value) in message where key == "get" {
            if let object = value as? String {
                if object == "vehicles" {
                    replyHandler(["vehicles" : vehicles.map { $0.name }])
                }
            }
        }
    }
}

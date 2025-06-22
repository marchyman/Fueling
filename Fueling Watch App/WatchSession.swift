//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import Foundation
import OSLog
import UDF
import WatchConnectivity

@MainActor
final class WatchSession: NSObject {
    let session: WCSession = .default
    unowned let store: Store<WatchState, WatchAction>
    var timer: Task<(), Never>?

    init(store: Store<WatchState, WatchAction>) {
        self.store = store
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            Logger(subsystem: "org.snafu", category: "WatchSession")
                .notice("Session not supported")
        }
    }
}

// messages sent from the watch to the app
extension WatchSession {
    // request a state update from the app
    func getVehicles() {
        guard session.isCompanionAppInstalled else {
            Logger(subsystem: "org.snafu", category: "WatchSession")
                .debug("\(#function) companion app not installed")
            return
        }
        guard session.isReachable else {
            Logger(subsystem: "org.snafu", category: "WatchSession")
                .debug("\(#function) session not reachable")
            return
        }
        timer = Task {
            // There may never be a response as a result of a fetch
            // request.  Reset the fetch state after a suitable timeout
            // period.
            try? await Task.sleep(for: .seconds(2))
            if store.state.fetching {
                await self.store.send(.watchSendError(fetchRequest: true))
            }
        }
        session.sendMessage([MessageKey.get: MessageKey.vehicles],
                            replyHandler: nil) { error in
            // got an error
            self.store.send(.watchSendError(fetchRequest: true))
            Logger(subsystem: "org.snafu", category: "WatchSession")
                .error("\(#function) error: \(error, privacy: .public)")
        }
    }

    // send a fueling update to the app
    func putFueling(vehicle: Vehicle,
                    cost: Double,
                    gallons: Double,
                    odometer: Double ) {
        if session.isReachable {
            Logger(subsystem: "org.snafu", category: "WatchSession")
                .debug("\(#function) \(vehicle.name, privacy: .public)")
            var plist: [String: Any] = [:]
            plist[MessageKey.vehicle] = vehicle.name
            plist[MessageKey.cost] = cost
            plist[MessageKey.gallons] = gallons
            plist[MessageKey.miles] = Int(odometer)
            session.sendMessage([MessageKey.put: plist]) { response in
                self.store.send(.receivedFuelingResponse)
                let value = response[MessageKey.put] as? String ?? "Bad response"
                if value != MessageKey.received {
                    Logger(subsystem: "org.snafu", category: "WatchSession")
                        .error("\(#function) \(value, privacy: .public)")
                }
            } errorHandler: { error in
                // got an error
                self.store.send(.watchSendError(fetchRequest: false))
                Logger(subsystem: "org.snafu", category: "WatchSession")
                    .error("\(#function) error: \(error, privacy: .public)")
            }
        }
    }
}

// WCSessionDelegate functions

extension WatchSession: WCSessionDelegate {
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        Logger(subsystem: "org.snafu", category: "WatchSession")
            .notice("\(#function) \(activationState.rawValue)")
        if activationState == .activated {
            Task { @MainActor in
                store.send(.watchSessionActivated(self)) {
                    if store.state.fetchStatus == .fetchRequested {
                        getVehicles()
                    }
                }
            }
        }
    }

    // the only data the watch expects to recieve that isn't a response to
    // message sent is an application context update. Process that here.
    nonisolated func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        var vehicles: [Vehicle] = []

        Logger(subsystem: "org.snafu", category: "WatchSession")
            .notice("\(#function) \(applicationContext.debugDescription, privacy: .public)")

        for (key, value) in applicationContext {
            do {
                let vehicle = try Vehicle(from: key, value: value)
                vehicles.append(vehicle)
            } catch {
                Logger(subsystem: "org.snafu", category: "WatchSession")
                    .error("\(#function) \(error.localizedDescription, privacy: .public)")
            }
        }
        let sortedVehicles = vehicles.sorted()
        Task { @MainActor in
            if let timer {
                // cancel and clear any running timer
                timer.cancel()
                self.timer = nil
            }
            store.send(.receivedAppContext(sortedVehicles))
        }
    }
}

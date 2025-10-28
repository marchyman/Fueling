//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import Foundation
import SwiftUI
import UDF

enum WatchFetchStatus {
    case idle, fetchRequested, dupRequest
}

enum WatchSendStatus {
    case idle, sendRequested, dupRequest
}

struct WatchState {
    var vehicles: [Vehicle] = []
    var watchSession: WatchSession?
    var fetchStatus: WatchFetchStatus = .idle
    var fetching: Bool {
        fetchStatus != .idle
    }
    var sendStatus: WatchSendStatus = .idle
}

enum WatchEvent {
    case contentViewAppeared
    case downloadButtonTapped
    case receivedAppContext([Vehicle])
    case receivedFuelingResponse
    case sendFuelButtonTapped
    case watchSessionActivated(WatchSession)
    case watchSessionReachable
    case watchSendError(fetchRequest: Bool)
}

struct WatchReducer: Reducer {
    func reduce(_ state: WatchState, _ event: WatchEvent) -> WatchState {
        var newState = state

        switch event {
        case .contentViewAppeared:
            if newState.vehicles.isEmpty
                && newState.watchSession != nil
                && newState.fetchStatus == .idle {
                newState.fetchStatus = .fetchRequested
            }
        case .downloadButtonTapped:
            if newState.watchSession != nil {
                if newState.fetchStatus == .idle {
                    newState.fetchStatus = .fetchRequested
                } else {
                    newState.fetchStatus = .dupRequest
                }
            }
        case .receivedAppContext(let vehicles):
            newState.fetchStatus = .idle
            newState.vehicles = vehicles
        case .receivedFuelingResponse:
            newState.sendStatus = .idle
        case .sendFuelButtonTapped:
            if newState.watchSession != nil {
                if newState.sendStatus == .idle {
                    newState.sendStatus = .sendRequested
                } else {
                    newState.sendStatus = .dupRequest
                }
            }
        case .watchSessionActivated(let ws):
            newState.watchSession = ws
        case .watchSessionReachable:
            if newState.fetchStatus == .idle {
                newState.fetchStatus = .fetchRequested
            }
        case .watchSendError(let fetchRequest):
            if fetchRequest {
                newState.fetchStatus = .idle
            } else {
                newState.sendStatus = .idle
            }
        }

        return newState
    }
}

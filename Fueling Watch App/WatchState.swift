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

enum WatchAction {
    case contentViewAppeared
    case downloadButtonTapped
    case receivedAppContext([Vehicle])
    case receivedFuelingResponse
    case watchSessionActivated(WatchSession)
    case watchSessionReachable
    case watchSendError(fetchRequest: Bool)
}

struct WatchReducer: Reducer {
    func reduce(_ state: WatchState, _ action: WatchAction) -> WatchState {
        var newState = state

        switch action {
        case .contentViewAppeared:
            if newState.vehicles.isEmpty
                && newState.watchSession != nil
                && newState.fetchStatus == .idle {
                newState.fetchStatus = .fetchRequested
            }
        case .downloadButtonTapped:
            if newState.watchSession != nil && newState.fetchStatus == .idle {
                newState.fetchStatus = .fetchRequested
            }
        case .receivedAppContext(let vehicles):
            newState.fetchStatus = .idle
            newState.vehicles = vehicles
        case .receivedFuelingResponse:
            newState.sendStatus = .idle
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

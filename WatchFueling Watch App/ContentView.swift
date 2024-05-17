//
//  ContentView.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/2/24.
//

import SwiftUI

struct ContentView: View {
    let pairedSession = WatchSession()
    @State private var vehicles: [String] = []
    @State private var selection: String?

    var body: some View {
        NavigationSplitView {
            if vehicles.isEmpty {
                Text("No Vehicles Found")
            }
            List(vehicles, id: \.self, selection: $selection) { vehicle in
                NavigationLink(value: vehicle) {
                    Text("\(vehicle)")
                }
            }
        } detail: {
            Text("detail view for \(selection ?? "unk")")
        }
        .padding()
        Button("Fetch vehicles") {
            if pairedSession.isReachable {
                pairedSession.session.sendMessage(["get" : "vehicles"],
                                                  replyHandler: gotVehicles,
                                                  errorHandler: errorHandler)
                WatchSession.log.notice("Sent get vehicles request.")
            }
        }
    }

    @MainActor
    func gotVehicles(_ response: [String : Any]) {
        WatchSession.log.notice("Rcvd response")
        for (key, value) in response where key == "vehicles" {
            if let allVehicles = value as? [String] {
                vehicles = allVehicles
            }
        }
    }

    @MainActor
    func errorHandler(error: Error) {
        WatchSession.log.error("Error: \(error.localizedDescription)")
    }
}

#Preview {
    ContentView()
}

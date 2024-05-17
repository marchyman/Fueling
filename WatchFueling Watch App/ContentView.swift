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
            List(vehicles, id: \.self, selection: $selection) { vehicle in
                NavigationLink(value: vehicle) {
                    Text("\(vehicle)")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if pairedSession.isReachable {
                            pairedSession.session.sendMessage(["get" : "vehicles"],
                                                              replyHandler: gotVehicles,
                                                              errorHandler: errorHandler)
                            WatchSession.log.notice("Sent get vehicles request.")
                        }
                    } label: {
                       Image(systemName: "square.and.arrow.down.fill")
                    }
                }
            }
            .navigationTitle("Select Vehicle")
        } detail: {
            Text("detail view for \(selection ?? "unk")")
        }
        .padding()
    }

    @MainActor
    func gotVehicles(_ response: [String : Any]) {
        WatchSession.log.notice("Rcvd response:")
        for (key, value) in response where key == "vehicles" {
            WatchSession.log.debug("vehicles key")
            if let allVehicles = value as? [String] {
                vehicles = allVehicles
                WatchSession.log.debug("vehicles: \(vehicles.debugDescription)")
            } else {
                WatchSession.log.debug("vehicles not set")
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

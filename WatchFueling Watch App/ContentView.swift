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
        } detail: {
            Text("detail view for \(selection ?? "unk")")
        }
        .padding()
        .onAppear {
//            if pairedSession.isReachable {
                pairedSession.session.sendMessage(["get" : "vehicles"],
                                                  replyHandler: gotVehicles)
                WatchSession.log.notice("Sent get vehicles request.")
//            }
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
}

#Preview {
    ContentView()
}

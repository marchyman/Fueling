//
//  ContentView.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/5/23.
//

import SwiftUI
import SwiftData

@MainActor
struct ContentView: View {
    @Environment(FuelingState.self) var state

    @State var path = NavigationPath()
    @State private var addVehiclePresented = false

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(state.vehicles) { vehicle in
                    NavigationLink {
                        VehicleView(vehicle: vehicle)
                    } label: {
                        Text(vehicle.name)
                    }
                }
                .onDelete(perform: deleteVehicle)
            }
            .navigationTitle("Select Vehicle")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .disabled(state.vehicles.isEmpty)
                }
                ToolbarItem {
                    Button(action: addVehicle) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .sheet(isPresented: $addVehiclePresented) {
                        AddVehicleView()
                    }
                }
            }
            .overlay {
                if state.vehicles.isEmpty {
                    ContentUnavailableView("Please add a vehicle",
                                           systemImage: "car.fill")
                }
            }
        }
        Text("Version \(appVersion != nil ? appVersion! : "Unknown")")
            .padding()
    }
}

extension ContentView {

    private func addVehicle() {
        addVehiclePresented.toggle()
    }

    private func deleteVehicle(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                state.delete(vehicle: state.vehicles[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(FuelingState(forPreview: true))
}

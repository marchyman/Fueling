//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import SwiftUI
import UDF

struct ContentView: View {
    @Environment(Store<FuelingState, FuelingEvent>.self) var store

    @State var path = NavigationPath()
    @State private var addVehiclePresented = false

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    private let testIDs = TestIDs.ContentView.self

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(store.vehicles) { vehicle in
                    NavigationLink {
                        VehicleView(vehicle: vehicle)
                    } label: {
                        Text(vehicle.name)
                    }
                    .accessibilityIdentifier(testIDs.vehicleButtonID(vehicle.name))
                }
                .onDelete(perform: deleteVehicle)
            }
            .navigationTitle("Select Vehicle")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .disabled(store.vehicles.isEmpty)
                        .accessibilityIdentifier(testIDs.editButtonID)
                }
                ToolbarItem {
                    Button {
                        addVehiclePresented.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                    .accessibilityIdentifier(testIDs.addButtonID)
                    .sheet(isPresented: $addVehiclePresented) {
                        AddVehicleView()
                    }
                }
            }
            .overlay {
                if store.vehicles.isEmpty {
                    ContentUnavailableView(
                        "Please add a vehicle",
                        systemImage: "car.fill")
                        .accessibilityIdentifier(testIDs.noContentID)
                }
            }
        }

        Text("Version \(appVersion != nil ? appVersion! : "Unknown")")
            .accessibilityIdentifier(testIDs.versionStringID)
            .padding()
    }
}

extension ContentView {
    private func deleteVehicle(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                store.send(.onDeleteRequested(vehicle: store.vehicles[index]))
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Store(initialState: FuelingState(forPreview: true),
                           reduce: FuelingReducer(),
                           name: "Fueling Store Preview"))
}

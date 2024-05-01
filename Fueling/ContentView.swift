//
//  ContentView.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/5/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var path = NavigationPath()
    @State private var addVehiclePresented = false
    @Query private var vehicles: [Vehicle]

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(vehicles) { vehicle in
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
                        .disabled(vehicles.isEmpty)
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
                if vehicles.isEmpty {
                    ContentUnavailableView("Please add a vehicle",
                                           systemImage: "car.fill")
                }
            }
        }
    }

    private func addVehicle() {
        addVehiclePresented.toggle()
    }

    private func deleteVehicle(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(vehicles[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Fuel.self)
}

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
    @State private var addVehiclePresented = false
    @Query private var vehicles: [Vehicle]

    var body: some View {

        NavigationSplitView {
            List {
                ForEach(vehicles) { vehicle in
                    NavigationLink {
                        Text(vehicle.name)
                    } label: {
                        Text(vehicle.name)
                    }
                }
                .onDelete(perform: deleteVehicle)
            }
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
        } detail: {
            Text("Select an item")
        }
    }

    private func addVehicle() {
        addVehiclePresented.toggle()
//        withAnimation {
//            let newVehicle = Vehicle(timestamp: Date())
//            modelContext.insert(newVehicle)
//        }
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
        .modelContainer(for: Vehicle.self, inMemory: true)
}

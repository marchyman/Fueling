//
//  VehicleView.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/7/23.
//

import SwiftData
import SwiftUI

struct VehicleView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var vehicle: Vehicle
    @State private var addFuelPresented = false
    @State private var fuelingInfoItem: Fuel?
    @State private var fuelingEditItem: Fuel?

    var body: some View {
        let _ = Self._printChanges()
        VStack {
            GroupBox {
                Grid(alignment: .leading, horizontalSpacing: 30) {
                    GridRow {
                        Text("Odometer start:")
                        Text("\(vehicle.odometer)")
                    }
                    GridRow {
                        Text("Fuel used:")
                        Text("\(vehicle.fuelUsed, specifier: "%.3f")")
                    }
                    GridRow {
                        Text("Miles driven:")
                        Text("\(vehicle.milesDriven, format: .number)")
                    }
                    GridRow {
                        Text("Miles/gallon:")
                        Text("\(vehicle.mpg, specifier: "%0.1f")")
                    }
                    GridRow {
                        Text("Total cost:")
                        Text("\(vehicle.fuelCost, format: .currency(code: "usd"))")
                    }
                    GridRow {
                        Text("Cost/gallon")
                        Text("\(vehicle.costPerGallon, format: .currency(code: "usd"))")
                    }
                    GridRow {
                        Text("Cost/mile")
                        Text("\(vehicle.costPerMile, format: .currency(code: "usd"))")
                    }
                }
            } label: {
                HStack {
                    Text("\(vehicle.name)")
                    Spacer()
                    Text(vehicle.initialTimestamp.formatted(date: .abbreviated,
                                                            time: .omitted))
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            Text("Recent refuelings")
                .font(.title)
                .padding()

            Grid(alignment: .trailing, horizontalSpacing: 30) {
                GridRow {
                    Text("Date/Time").font(.headline)
                    Text("Odometer").font(.headline)
                    Text("Gallons").font(.headline)
                    Text("Cost").font(.headline)
                }
            }

            List {
                ForEach(vehicle.fuelingsByTimestamp()) { fueling in
                    FuelingView(fueling: fueling)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            fuelingInfoItem = fueling
                        }
                        .onLongPressGesture {
                            fuelingEditItem = fueling
                        }
                        .sheet(item: $fuelingInfoItem) { item in
                            FuelingInfoView(fueling: item)
                                .presentationDetents([.medium])
                        }
                        .sheet(item: $fuelingEditItem) { item in
                            FuelingEditView(fueling: item)
                                .presentationDetents([.medium])
                        }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Vehicle Fuel Use")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .disabled(vehicle.fuelings.isEmpty)
            }

            ToolbarItem {
                Button(action: { addFuelPresented.toggle() }) {
                    Label("Add fuel", systemImage: "plus")
                }
                .sheet(isPresented: $addFuelPresented) {
                    AddFuelView(vehicle: vehicle)
                }
            }
        }
    }
}

#Preview {
    let container = Vehicle.preview
    let fetchDescriptor = FetchDescriptor<Vehicle>()
    let vehicle = try! container.mainContext.fetch(fetchDescriptor)[0]
    return NavigationStack {
        VehicleView(vehicle: vehicle)
    }
}

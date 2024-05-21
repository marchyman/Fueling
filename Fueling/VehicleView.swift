//
//  VehicleView.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/7/23.
//

import SwiftData
import SwiftUI

struct VehicleView: View {
    @Environment(FuelingState.self) var state

    var vehicle: Vehicle

    @State private var addFuelPresented = false
    @State private var fuelingInfoItem: Fuel?
    @State private var fuelingEditItem: Fuel?

    var body: some View {
        let _ = Self._printChanges()
        ScrollView {
            GroupBox {
                Grid(alignment: .leading, horizontalSpacing: 30) {
                    GridRow {
                        Text("Total cost:")
                        Text("\(vehicle.fuelCost, format: .currency(code: "usd"))")
                    }
                    GridRow {
                        Text("Fuel used:")
                        Text("\(vehicle.fuelUsed, specifier: "%.3f")")
                    }
                    GridRow {
                        Text("Miles driven:")
                        Text("\(vehicle.milesDriven, format: .number)")
                    }
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    GridRow {
                        Text("Miles/gallon:")
                        Text("\(vehicle.mpg, specifier: "%0.1f")")
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
                    Text("\(vehicle.odometer) miles")
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            Text("Recent refuelings")
                .font(.title)
                .padding()

            Grid(alignment: .trailingFirstTextBaseline,
                 horizontalSpacing: 10,
                 verticalSpacing: 10) {
                GridRow {
                    Text("Date/Time")
                    Text("Odometer")
                    Text("Gallons")
                        .gridColumnAlignment(.center)
                    Text("Cost")
                        .gridColumnAlignment(.center)
                }
                .font(.headline)
                Divider()
                ForEach(vehicle.fuelingsByTimestamp()) { fueling in
                    GridRow {
                        Text("\(fueling.dateTime)")
                        Text("\(fueling.odometer, format: .number)")
                        Text("\(fueling.amount, specifier: "%.3f")")
                        Text("\(fueling.cost, format: .currency(code: "usd"))")
                            .frame(maxWidth: 70, alignment: .trailing)
                    }
                    .onTapGesture {
                        fuelingInfoItem = fueling
                    }
                    .sheet(item: $fuelingInfoItem) { item in
                        FuelingInfoView(fueling: item)
                            .presentationDetents([.medium])
                    }
                    .onLongPressGesture {
                        fuelingEditItem = fueling
                    }
                    .sheet(item: $fuelingEditItem) { item in
                        FuelingEditView(fueling: item)
                            .presentationDetents([.medium])
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Vehicle Fuel Use")
        .toolbar {
            ToolbarItem {
                Button { addFuelPresented.toggle() } label: {
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
    let state = FuelingState(forPreview: true)
    return NavigationStack {
        VehicleView(vehicle: state.vehicles[0])
            .environment(state)
    }
}

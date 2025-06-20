//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import SwiftUI

struct VehicleView: View {
    var vehicle: Vehicle

    @State private var addFuelPresented = false
    @State private var fuelingInfoItem: Fuel?
    @State private var fuelingEditItem: Fuel?

    var body: some View {
        ScrollView {
            GroupBox {
                Grid(alignment: .leading, horizontalSpacing: 30) {
                    GridRow {
                        Text("Total cost:")
                        Text("\(vehicle.fuelCost, format: .currency(code: "usd"))")
                            .monospacedDigit()
                    }
                    GridRow {
                        Text("Fuel used:")
                        Text("\(vehicle.fuelUsed, specifier: "%.3f")")
                            .monospacedDigit()
                    }
                    GridRow {
                        Text("Miles driven:")
                        Text("\(vehicle.milesDriven, format: .number)")
                            .monospacedDigit()
                    }
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    GridRow {
                        Text("Miles/gallon:")
                        Text("\(vehicle.mpg, specifier: "%0.1f")")
                            .monospacedDigit()
                    }
                    GridRow {
                        Text("Cost/gallon")
                        Text("\(vehicle.costPerGallon, format: .currency(code: "usd"))")
                            .monospacedDigit()
                    }
                    GridRow {
                        Text("Cost/mile")
                        Text("\(vehicle.costPerMile, format: .currency(code: "usd"))")
                            .monospacedDigit()
                    }
                }
            } label: {
                HStack {
                    Text("\(vehicle.name)")
                    Spacer()
                    VStack {
                        Text("\(vehicle.odometer) start")
                            .monospacedDigit()
                        Text(
                            "\(vehicle.fuelingsByTimestamp().first?.odometer ?? vehicle.odometer) miles"
                        )
                        .monospacedDigit()
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            Text("Recent refuelings")
                .font(.title)
                .padding()

            Grid(
                alignment: .trailingFirstTextBaseline,
                horizontalSpacing: 10,
                verticalSpacing: 10
            ) {
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
                        Group {
                            Text("\(fueling.dateTime)")
                            Text("\(fueling.odometer, format: .number)")
                            Text("\(fueling.amount, specifier: "%.3f")")
                            Text("\(fueling.cost, format: .currency(code: "usd"))")
                                .frame(maxWidth: 70, alignment: .trailing)
                        }
                        .monospacedDigit()
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
                Button {
                    addFuelPresented.toggle()
                } label: {
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
    @Previewable @State var store =
        Store(initialState: FuelingState(forPreview: true),
              reduce: FuelingReducer(),
              name: "Fueling Store Preview")
    NavigationStack {
        VehicleView(vehicle: store.state.vehicles[0])
    }
}

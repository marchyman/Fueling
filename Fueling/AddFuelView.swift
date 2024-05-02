//
//  AddFuelView.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/1/24.
//

import SwiftData
import SwiftUI

struct AddFuelView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    var vehicle: Vehicle
    @State private var odometer: Int?
    @State private var gallons: Double?
    @State private var cost: Double?

    var body: some View {
        VStack {
            Text("Add Fuel")
                .font(.title)
                .padding(.bottom)

            Form {
                Text(vehicle.name).font(.headline)
                LabeledContent("Current odometer:") {
                    TextField("Required",
                              value: $odometer,
                              format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }

                LabeledContent("Number of gallons") {
                    TextField("Required",
                              value: $gallons,
                              format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }

                LabeledContent("Cost") {
                    TextField("Required",
                              value: $cost,
                              format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
            }
            .frame(height: 250)
            HStack {
                Spacer()
                Button("Cancel", role: .cancel) {
                    dismiss()
                }

                Button("Add") {
                    addFuel()
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .disabled(!validInput())
            }
        }
    }

    private func validInput() -> Bool {
        guard
            let odometer,
            let gallons,
            let cost,
            odometer != 0,
            gallons != 0,
            cost != 0 else { return false }
        return true
    }

    private func addFuel() {
        guard
            let odometer,
            let gallons,
            let cost else { return }
        let fuel = Fuel(vehicle, odometer: odometer,
                        amount: gallons, cost: cost)
        modelContext.insert(fuel)
        vehicle.fuelings.append(fuel)
    }
}

#Preview {
    let container = Vehicle.preview
    let fetchDescriptor = FetchDescriptor<Vehicle>()
    let vehicle = try! container.mainContext.fetch(fetchDescriptor)[0]
    return AddFuelView(vehicle: vehicle)
        .modelContainer(for: Vehicle.self, inMemory: true)
}

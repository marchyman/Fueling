//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import SwiftUI
import UDF

struct AddFuelView: View {
    @Environment(Store<FuelingState, FuelingEvent>.self) var store
    @Environment(\.dismiss) var dismiss

    var vehicle: Vehicle

    @State private var gallons: Double?
    @State private var cost: Double?
    @State private var odometer: Int?

    private let testIDs = TestIDs.AddFuelView.self

    var body: some View {
        VStack {
            Text("Add Fuel")
                .font(.title)
                .padding(.bottom)

            Form {
                Text(vehicle.name).font(.headline)
                    .accessibilityIdentifier(testIDs.nameID)

                LabeledContent("Cost") {
                    TextField(
                        "Required",
                        value: $cost,
                        format: .number
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .accessibilityIdentifier(testIDs.costID)
                }

                LabeledContent("Number of gallons") {
                    TextField(
                        "Required",
                        value: $gallons,
                        format: .number
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .accessibilityIdentifier(testIDs.gallonsID)
                }

                LabeledContent("Current odometer") {
                    TextField(
                        "Required",
                        value: $odometer,
                        format: .number
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .accessibilityIdentifier(testIDs.odometerID)
                }
            }
            .frame(height: 250)
            HStack {
                Spacer()
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .accessibilityIdentifier(testIDs.cancelButtonID)

                Button("Add") {
                    if let cost, let gallons, let odometer {
                        let fuelData = FuelData(odometer: odometer,
                                                amount: gallons,
                                                cost: cost)
                        store.send(.addFuelButtonTapped(vehicle.name,
                                                        fuelData))
                        dismiss()
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .disabled(!validInput())
                .accessibilityIdentifier(testIDs.addButtonID)
            }
        }
    }
}

extension AddFuelView {
    private func validInput() -> Bool {
        guard
            let odometer,
            let gallons,
            let cost,
            odometer != 0,
            gallons != 0,
            cost != 0
        else { return false }
        return true
    }
}

#Preview {
    let state = FuelingState(forPreview: true)
    AddFuelView(vehicle: state.vehicles[0])
        .environment(Store(initialState: state,
                           reduce: FuelingReducer(),
                           name: "Fueling Store Preview"))
}

//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import SwiftUI
import UDF

struct FuelingEditView: View {
    @Environment(Store<FuelingState, FuelingEvent>.self) var store
    @Environment(\.dismiss) var dismiss

    let fuelEntry: Fuel

    @State private var fuelData: FuelData

    private let testIDs = TestIDs.FuelingEditView.self

    init(fuelEntry: Fuel) {
        self.fuelEntry = fuelEntry
        _fuelData = State(initialValue: FuelData(odometer: fuelEntry.odometer,
                                                 amount: fuelEntry.amount,
                                                 cost: fuelEntry.cost))
    }

    var body: some View {
        VStack {
            Text("Edit Fuel")
                .font(.title)
                .padding(.bottom)
                .accessibilityIdentifier(testIDs.titleID)

            Form {
                Text(fuelEntry.vehicle?.name ?? "unknown").font(.headline)
                    .accessibilityIdentifier(testIDs.nameID)

                LabeledContent("Cost") {
                    TextField(
                        "Required",
                        value: $fuelData.cost,
                        format: .currency(code: "usd")
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .accessibilityIdentifier(testIDs.costID)
                }

                LabeledContent("Number of gallons") {
                    TextField(
                        "Required",
                        value: $fuelData.amount,
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
                        value: $fuelData.odometer,
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
                .padding()
                .accessibilityIdentifier(testIDs.cancelButtonID)

                Button("Update") {
                    store.send(.editFuelUpdateButtonTapped(fuelEntry.timestamp,
                                                           fuelData))
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier(testIDs.updateButtonID)
            }
        }
    }
}

#Preview {
    let state = FuelingState(forPreview: true)
    let fueling = state.vehicles.first!.fuelings.first!
    FuelingEditView(fuelEntry: fueling)
}

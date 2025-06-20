//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import SwiftUI
import UDF

struct AddVehicleView: View {
    @Environment(Store<FuelingState, FuelingAction>.self) var store
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var odometer: Int?

    var body: some View {
        VStack {
            Text("Add Vehicle")
                .font(.title)
                .padding(.bottom)

            Form {
                LabeledContent("Vehicle Name:") {
                    TextField("Required", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                LabeledContent("Current odometer:") {
                    TextField(
                        "Required",
                        value: $odometer,
                        format: .number
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
            }
            .frame(height: 160)
            HStack {
                Spacer()
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                Button("Add") {
                    guard let odometer else { return }
                    let newVehicle = Vehicle(name: name, odometer: odometer)
                    store.send(.addVehicleButtonTapped(newVehicle))
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .disabled(!validInput())
            }
            Spacer()
        }
    }
}

// Helper functions
extension AddVehicleView {

    // name must not be empty or already exist
    // odometer must be > 0
    private func validInput() -> Bool {
        guard let odometer else { return false }
        guard !name.isEmpty && odometer > 0 else { return false }
        return !store.state.vehicles.contains(where: { $0.name == name })
    }
}

#Preview {
    AddVehicleView()
        .environment(Store(initialState: FuelingState(forPreview: true),
                           reduce: FuelingReducer(),
                           name: "Fueling Store Preview"))
}

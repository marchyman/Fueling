//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import SwiftUI

struct AddVehicleView: View {
    @Environment(FuelingState.self) var state
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
                    addVehicle()
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
        return !state.vehicles.contains(where: { $0.name == name })
    }

    private func addVehicle() {
        guard let odometer else { return }
        let newVehicle = Vehicle(name: name, odometer: odometer)
        state.create(vehicle: newVehicle)
    }
}

#Preview {
    AddVehicleView()
        .environment(FuelingState(forPreview: true))
}

//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import SwiftUI

struct KeypadView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var value: Double
    let title: String

    @State private var stringValue: String = "0"

    var body: some View {
        VStack(alignment: .trailing) {
            Text(stringValue)
                .bold()
            Grid(alignment: .bottom) {
                GridRow {
                    KeyCap("1", keyHit: addChar)
                    KeyCap("2", keyHit: addChar)
                    KeyCap("3", keyHit: addChar)
                }
                GridRow {
                    KeyCap("4", keyHit: addChar)
                    KeyCap("5", keyHit: addChar)
                    KeyCap("6", keyHit: addChar)
                }
                GridRow {
                    KeyCap("7", keyHit: addChar)
                    KeyCap("8", keyHit: addChar)
                    KeyCap("9", keyHit: addChar)
                }
                GridRow {
                    KeyCap(".", keyHit: addChar)
                    KeyCap("0", keyHit: addChar)
                    Image(systemName: "delete.left.fill")
                        .frame(width: 50, height: 32)
                        .background(.gray)
                        .cornerRadius(7)
                        .onTapGesture {
                            deleteChar()
                        }
                }
            }
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.footnote)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    value = Double(stringValue) ?? 0
                    dismiss()
                }
                .font(.caption2)
                .buttonStyle(.plain)
            }
        }
        .onAppear {
            stringValue = String(value)
        }
    }
}

extension KeypadView {

    private func addChar(_ key: Character) {
        if key == "." && stringValue.contains(".") { return }
        if Double(stringValue) == 0.0 {
            stringValue = String(key)
        } else {
            stringValue.append(key)
        }
    }

    private func deleteChar() {
        guard !stringValue.isEmpty else { return }
        if stringValue.count == 1 {
            stringValue = "0"
        } else {
            stringValue.remove(at: stringValue.index(before: stringValue.endIndex))
        }
    }
}

struct KeyCap: View {
    let keyCap: Character
    let keyHit: (Character) -> Void

    init(_ keyCap: Character, keyHit: @escaping (Character) -> Void ) {
        self.keyCap = keyCap
        self.keyHit = keyHit
    }

    var body: some View {
        Text(String(keyCap))
            .frame(width: 50, height: 32)
            .background(.gray)
            .cornerRadius(7)
            .onTapGesture {
                keyHit(keyCap)
            }
    }
}

#Preview {
    NavigationStack {
        KeypadView(value: .constant(1.23), title: "Odometer")
    }
}

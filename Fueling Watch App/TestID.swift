//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import Foundation

enum TestID {
    static let vehicleButton = "ContentView.button.vehicleName"
    static let downloadButton = "ContentView.button.download"

    static let totalCost = "VehicleDetailView.staticText.cost"
    static let totalGallons = "VehicleDetailView.staticText.gallons"
    static let totalMiles = "VehicleDetailView.staticText.miles"
    static let totalMPG = "VehicleDetailView.staticText.mpg"
    static let totalCPG = "VehicleDetailView.staticText.cpg"
    static let fuelEntryButton = "VehicleDetailView.button.fuelEntry"

    static let entryCost = "FuelEntryView.button.cost"
    static let entryGallons = "FuelEntryView.button.gallons"
    static let entryOdometer = "FuelEntryView.button.odometer"
    static let entryUploadButton = "FuelEntryView.button.upload"

    static let keycapButtonCancel = "KeypadView.button.x"
    static let keycapButtonDone = "KeypadView.button.done"

    static func keycapButton(_ keyCap: String) -> String {
        "KeypadView.button.\(keyCap)"
    }
}

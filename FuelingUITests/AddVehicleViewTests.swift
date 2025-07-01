//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import XCTest

@MainActor
final class AddVehicleViewTests: XCTestCase {

    private var app: XCUIApplication!
    private let testIDs = TestIDs.AddVehicleView.self

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation
        // of each test method in the class.

        // In UI tests it is usually best to stop immediately when a
        // failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as
        // interface orientation - required for your tests before they run.
        // The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddVehicleView() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.addButtonID].tap()
        XCTAssert(app.textFields[testIDs.vehicleNameID].exists)
        XCTAssert(app.textFields[testIDs.odometerID].exists)
        XCTAssert(app.buttons[testIDs.cancelButtonID].exists)
        XCTAssert(app.buttons[testIDs.addButtonID].exists)
        XCTAssert(!app.buttons[testIDs.addButtonID].isEnabled)
        app.buttons[testIDs.cancelButtonID].tap()
        XCTAssert(!app.textFields[testIDs.vehicleNameID].exists)
    }

    func testAddingVehicle() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        // add a vehicle

        app.buttons[TestIDs.ContentView.addButtonID].tap()
        let vehicleField = app.textFields[testIDs.vehicleNameID]
        vehicleField.tap() // force keyboard focus
        vehicleField.typeText("New Vehicle")
        XCTAssert(!app.buttons[testIDs.addButtonID].isEnabled)

        let odometerField = app.textFields[testIDs.odometerID]
        odometerField.tap()
        odometerField.typeText("12345")
        XCTAssert(app.buttons[testIDs.addButtonID].isEnabled)
        app.buttons[testIDs.addButtonID].tap()

        // Verify vehicle added

        XCTAssert(app.buttons[TestIDs.ContentView.vehicleButtonID("New Vehicle")].exists)
    }

    func testCancelAdd() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        // fill in the fields

        app.buttons[TestIDs.ContentView.addButtonID].tap()
        let vehicleField = app.textFields[testIDs.vehicleNameID]
        vehicleField.tap() // force keyboard focus
        vehicleField.typeText("New Vehicle")
        XCTAssert(!app.buttons[testIDs.addButtonID].isEnabled)

        let odometerField = app.textFields[testIDs.odometerID]
        odometerField.tap()
        odometerField.typeText("12345")
        XCTAssert(app.buttons[testIDs.addButtonID].isEnabled)

        // hit the cancel button

        app.buttons[testIDs.cancelButtonID].tap()
        XCTAssert(!app.buttons[TestIDs.ContentView.vehicleButtonID("New Vehicle")].exists)
    }
}

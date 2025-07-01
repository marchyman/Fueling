//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import XCTest

@MainActor
final class FxAddFuelViewTests: XCTestCase {

    private var app: XCUIApplication!
    private let testIDs = TestIDs.AddFuelView.self

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

    // check view elements exist and tapping the cancel button removes the view
    func testAddFuelView() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        app.buttons[TestIDs.VehicleView.addFuelButtonID].tap()

        XCTAssert(app.staticTexts[testIDs.nameID].exists)
        XCTAssert(app.textFields[testIDs.costID].exists)
        XCTAssert(app.textFields[testIDs.gallonsID].exists)
        XCTAssert(app.textFields[testIDs.odometerID].exists)
        XCTAssert(app.buttons[testIDs.addButtonID].exists)
        XCTAssert(!app.buttons[testIDs.addButtonID].isEnabled)
        XCTAssert(app.buttons[testIDs.cancelButtonID].exists)
        app.buttons[testIDs.cancelButtonID].tap()
        XCTAssert(!app.buttons[testIDs.cancelButtonID].exists)
    }

    // Data Entry and add button validation

    func testAddButton() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        app.buttons[TestIDs.VehicleView.addFuelButtonID].tap()

        let addButton = app.buttons[testIDs.addButtonID]
        XCTAssert(!addButton.isEnabled)

        let cost = app.textFields[testIDs.costID]
        cost.tap()
        cost.typeText("10.23")
        XCTAssert(!addButton.isEnabled)

        let gallons = app.textFields[testIDs.gallonsID]
        gallons.tap()
        gallons.typeText("1.943")
        XCTAssert(!addButton.isEnabled)

        let odometer = app.textFields[testIDs.odometerID]
        odometer.tap()
        odometer.typeText("12734")
        XCTAssert(addButton.isEnabled)

        addButton.tap()

        // there should now be 3 fueling entries
        XCTAssert(app.staticTexts.matching(identifier: TestIDs.VehicleView.fuelingDateTimeID).count == 3)
    }
}

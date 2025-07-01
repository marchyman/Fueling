//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import XCTest

@MainActor
final class DxFuelingEditTests: XCTestCase {

    private var app: XCUIApplication!
    private let testIDs = TestIDs.FuelingEditView.self

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

    func testFuelingEditView() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        let entry = app.staticTexts.matching(identifier: TestIDs.VehicleView.fuelingDateTimeID).firstMatch
        entry.press(forDuration: 1.0)

        XCTAssert(app.staticTexts[testIDs.titleID].exists)
        XCTAssert(app.textFields[testIDs.costID].exists)
        XCTAssert(app.textFields[testIDs.costID].value as? String == "$10.17")
        XCTAssert(app.textFields[testIDs.gallonsID].exists)
        XCTAssert(app.textFields[testIDs.gallonsID].value as? String == "2.03")
        XCTAssert(app.textFields[testIDs.odometerID].exists)
        XCTAssert(app.textFields[testIDs.odometerID].value as? String == "12,666")
        XCTAssert(app.buttons[testIDs.cancelButtonID].exists)
        XCTAssert(app.buttons[testIDs.updateButtonID].exists)

        app.buttons[testIDs.cancelButtonID].tap()
        XCTAssert(!app.buttons[testIDs.cancelButtonID].exists)
    }

    func testEditCancel() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        let entry = app.staticTexts.matching(identifier: TestIDs.VehicleView.fuelingDateTimeID).firstMatch
        entry.press(forDuration: 1.0)

        let gallons = app.textFields[testIDs.gallonsID]
        gallons.doubleTap()
        gallons.typeText("2.13")
        app.buttons[testIDs.cancelButtonID].tap()

        // check that the entry didn't change

        entry.press(forDuration: 1.0)
        XCTAssert(app.textFields[testIDs.gallonsID].value as? String == "2.03")
    }

    func testEditUpdate() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        let entry = app.staticTexts.matching(identifier: TestIDs.VehicleView.fuelingDateTimeID).firstMatch
        entry.press(forDuration: 1.0)

        let cost = app.textFields[testIDs.costID]
        cost.doubleTap()
        cost.typeText("10.23")
        app.buttons[testIDs.updateButtonID].tap()

        // check that the entry updated

        entry.press(forDuration: 1.0)
        XCTAssert(app.textFields[testIDs.costID].value as? String == "$10.23")
    }
}

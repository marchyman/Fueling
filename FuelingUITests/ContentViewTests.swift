//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import XCTest

@MainActor
final class AxContentViewTests: XCTestCase {

    private var app: XCUIApplication!
    private let testIDs = TestIDs.ContentView.self

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

    // first time launch. DANGER: will delete all vehicles from any existing
    // database.  Intended for simulator use only.

    func testLaunch() {
        app = XCUIApplication()
        app.launchArguments.append("-EMPTY")
        app.launch()

        print(app.debugDescription)
        XCTAssert(app.images[testIDs.noContentID].exists)
        XCTAssert(app.staticTexts[testIDs.noContentID].exists)
        XCTAssert(app.buttons[testIDs.addButtonID].exists)
        XCTAssert(app.buttons[testIDs.editButtonID].exists)
        XCTAssert(!app.buttons[testIDs.editButtonID].isEnabled)
        XCTAssert(app.staticTexts[testIDs.versionStringID].exists)
    }

    // Check initial screen when using in memory test database.

    func testLaunchWithData() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        XCTAssert(app.buttons[testIDs.vehicleButtonID("Honda Accord")].exists)
        XCTAssert(app.buttons[testIDs.vehicleButtonID("KTM790")].exists)
        XCTAssert(app.buttons[testIDs.editButtonID].isEnabled)

        let editButton = app.buttons[testIDs.editButtonID]
        editButton.tap()
        XCTAssert(editButton.label == "Done")
        XCTAssert(!app.buttons[testIDs.vehicleButtonID("Honda Accord")].isEnabled)
        XCTAssert(!app.buttons[testIDs.vehicleButtonID("KTM790")].isEnabled)
        XCTAssert(app.images.matching(identifier: "minus.circle.fill").count == 2)
        editButton.tap()
        XCTAssert(editButton.label == "Edit")
    }

    func testDeleteVehicle() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[testIDs.vehicleButtonID("KTM790")].swipeLeft()
        XCTAssert(app.buttons["Delete"].exists)
        app.buttons["Delete"].tap()
        XCTAssert(!app.buttons[testIDs.vehicleButtonID("KTM790")].exists)
    }

    func testSelectVehicle() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[testIDs.vehicleButtonID("Honda Accord")].tap()
        XCTAssert(app.navigationBars["Vehicle Fuel Use"].exists)
    }
}

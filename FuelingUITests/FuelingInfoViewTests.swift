//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import XCTest

@MainActor
final class CxFuelingInfoViewTests: XCTestCase {

    private var app: XCUIApplication!
    private let testIDs = TestIDs.FuelingInfoView.self

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

    func testFuelingInfoView() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        let entry = app.staticTexts.matching(identifier: TestIDs.VehicleView.fuelingDateTimeID).firstMatch
        entry.tap()
        XCTAssert(app.staticTexts[testIDs.fuelUsedID].exists)
        XCTAssert(app.staticTexts[testIDs.milesDrivenID].exists)
        XCTAssert(app.staticTexts[testIDs.mpgID].exists)
        XCTAssert(app.staticTexts[testIDs.cpgID].exists)
        XCTAssert(app.staticTexts[testIDs.cpmID].exists)
        XCTAssert(app.staticTexts[testIDs.dateTimeID].exists)

        // the dismiss button is identified by the identifier
        // assigned to its view.

        let dismiss = app.buttons[TestIDs.VehicleView.fuelingInfoViewID]
        XCTAssert(dismiss.exists)
        dismiss.tap()
        XCTAssert(!dismiss.exists)
    }
}

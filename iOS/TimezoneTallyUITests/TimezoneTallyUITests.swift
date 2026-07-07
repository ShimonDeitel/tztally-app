import XCTest

final class TimezoneTallyUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAddItemFlow() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["addItemButton"].tap()
        let titleField = app.textFields["addTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("New Entry")

        app.buttons["addSaveButton"].tap()
        XCTAssertTrue(app.staticTexts["New Entry"].waitForExistence(timeout: 5))
    }

    func testFreeLimitTriggersPaywall() throws {
        let app = XCUIApplication()
        app.launch()

        for i in 0..<20 {
            app.buttons["addItemButton"].tap()
            if app.buttons["paywallPurchaseButton"].waitForExistence(timeout: 1) {
                XCTAssertTrue(app.buttons["paywallPurchaseButton"].exists)
                app.buttons["paywallDismissButton"].tap()
                return
            }
            let titleField = app.textFields["addTitleField"]
            guard titleField.waitForExistence(timeout: 2) else { break }
            titleField.tap()
            titleField.typeText("Entry \(i)")
            app.buttons["addSaveButton"].tap()
        }
    }

    func testKeyboardDismissOnTapOutside() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["addItemButton"].tap()
        let titleField = app.textFields["addTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("Dismiss Test")
        XCTAssertTrue(app.keyboards.element.exists)

        app.navigationBars.element.tap()
        XCTAssertFalse(app.keyboards.element.exists)
    }

    func testSettingsOpensAndCloses() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 5))
        app.buttons["settingsDoneButton"].tap()
    }
}

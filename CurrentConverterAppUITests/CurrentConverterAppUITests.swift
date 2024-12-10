import XCTest

final class CurrentConverterAppUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        // XCUIApplication().launch()
    }

    override func tearDownWithError() throws {}

    func testHomeViewElementsExist() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.HomeView.selectSourceCurrency].exists, "buttonOpenSourceCurrency should exist")
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.HomeView.fromButton].exists, "convertFromButton should exist")
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.HomeView.toButton].exists, "convertToButton should exist")
        XCTAssertTrue(app.textFields["Enter amount"].exists, "Enter text field should exist")
        XCTAssertTrue(app.staticTexts["-"].exists, "selectedCurrencyLabel should start with '-' label")
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.HomeView.convertButton].exists, "convertButton should exist")
    }

    func testCurrencyFromButtonSelection() {
        let app = XCUIApplication()
        app.launch()

        let fromButton = app.buttons[AccessibilityIdentifiers.HomeView.fromButton]

        fromButton.tap()
        XCTAssertTrue(app.otherElements[AccessibilityIdentifiers.SelectCurrencyScreen.screen].exists, "Should open selectCurrencyScreen from 'From'")
    }

    func testCurrencyToButtonSelection() {
        let app = XCUIApplication()
        app.launch()

        let toButton = app.buttons[AccessibilityIdentifiers.HomeView.toButton]
        toButton.tap()
        XCTAssertTrue(app.otherElements[AccessibilityIdentifiers.SelectCurrencyScreen.screen].exists, "Should open selectCurrencyScreen from 'To'")
    }

    func testCurrencyAmountTextField() {
        let app = XCUIApplication()
        app.launch()

        let textField = app.textFields[AccessibilityIdentifiers.HomeView.currencyAmountTextField]
        textField.tap()
        // textField.typeText("123.45")
        textField.typeText("12345")
        XCTAssertEqual(textField.value as? String, "12345", "Text field should include entered amount")
    }

    func testDoneButtonOnKeyboard() {
        let app = XCUIApplication()
        app.launch()

        let textField = app.textFields[AccessibilityIdentifiers.HomeView.currencyAmountTextField]
        textField.tap()
        XCTAssertTrue(app.keyboards.count > 0, "Keyboard should show")

        app.toolbars.buttons[AccessibilityIdentifiers.HomeView.keyboardDone].tap()
        XCTAssertEqual(app.keyboards.count, 0, "Keyboard should hide")
    }

    func testConvertWithoutInput() {
        let app = XCUIApplication()
        app.launch()

        let convertButton = app.buttons[AccessibilityIdentifiers.HomeView.convertButton]
        convertButton.tap()

        let resultLabel = app.staticTexts["-"]
        XCTAssertEqual(resultLabel.label, "-", "Label shouldn't change after button tap")
    }
}

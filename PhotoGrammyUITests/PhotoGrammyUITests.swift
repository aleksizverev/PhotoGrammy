import XCTest

let unsplashLogin = ""
let unsplashPassword = ""

final class PhotoGrammyUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(unsplashLogin)
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(unsplashPassword)
        webView.swipeUp()
        
        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        app.swipeUp()
        sleep(4)
        app.swipeDown()
        
        sleep(4)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons.firstMatch.tap()
    
        sleep(4)
        cellToLike.buttons.firstMatch.tap()

        sleep(4)
        cellToLike.tap()
        
        sleep(4)
        let image = app.scrollViews.images.element(boundBy: 0)
        
        sleep(4)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["John Doe"].exists)
        XCTAssertTrue(app.staticTexts["@spaghetti_banana"].exists)
        
        app.buttons["logout button"].tap()
        app.alerts["Goodbye!"].scrollViews.otherElements.buttons["Yes"].tap()
        
        sleep(2)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}

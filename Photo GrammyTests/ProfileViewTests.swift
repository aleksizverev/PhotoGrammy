@testable import PhotoGrammy
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let sut = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        sut.configure(presenter)
        
        //when
        _ = sut.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}


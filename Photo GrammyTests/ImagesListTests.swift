@testable import PhotoGrammy
import XCTest

final class ImagesListTest: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let sut = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        sut.configure(presenter)
        
        //when
        _ = sut.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}

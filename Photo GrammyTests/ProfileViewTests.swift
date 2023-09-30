@testable import PhotoGrammy
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let sut = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        sut.presenter = presenter
        
        //when
        _ = sut.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerSetsProfileDetails() {
        //given
        let sut = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        sut.configure(presenter)
        
        //when
        _ = sut.view
        
        //then
        XCTAssertEqual(sut.nameLabel.text, presenter.profileService.profile?.name)
        XCTAssertEqual(sut.userTagLabel.text, presenter.profileService.profile?.loginName)
        XCTAssertEqual(sut.userDescriptionLabel.text, presenter.profileService.profile?.bio)
    }
    
    func testPresenterCallsSetProfileAvatar(){
        //given
        let profileHelperStub = ProfileSetUpHelperStub()
        let sut = ProfilePresenter(profileSetUpHelper: profileHelperStub)
        let viewController = ProfileViewControllerSpy()
        viewController.configure(sut)
        
        //when
        sut.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.setProfileAvatarCalled)
    }
}


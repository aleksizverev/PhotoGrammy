import PhotoGrammy
import Foundation

class ProfileServiceStub {
    static let shared = ProfileServiceStub()
    var profile: PhotoGrammy.Profile? = {
        PhotoGrammy.Profile(username: "johndoe", name: "John Doe", loginName: "@johndoe", bio: "Hello, World!")
    }()
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: PhotoGrammy.ProfileViewControllerProtocol?
    var profileService = ProfileServiceStub.shared
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        updateProfileDetails()
        updateAvatar()
    }
    
    func updateAvatar() {}
    
    func updateProfileDetails() {
        view?.setProfileDetails(profile: profileService.profile)
    }
}

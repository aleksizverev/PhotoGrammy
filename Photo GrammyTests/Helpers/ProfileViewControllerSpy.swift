import PhotoGrammy
import UIKit
import Kingfisher

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var setProfileAvatarCalled: Bool = false
    var setProfileDetailsCalled: Bool = false
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func setProfileDetails(profile: Profile?) {
        setProfileDetailsCalled = true
    }
    
    func setProfileAvatar(with url: URL) {
        setProfileAvatarCalled = true
    }
}

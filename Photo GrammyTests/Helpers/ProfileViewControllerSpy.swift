@testable import PhotoGrammy
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var setProfileAvatarCalled: Bool = false
    var setProfileDetailsCalled: Bool = false
    var showAlertCalled: Bool = false
    
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
    
    func showAlert(alert: UIAlertController) {
        showAlertCalled = true
    }
    
    func exitFromProfile() {}
}

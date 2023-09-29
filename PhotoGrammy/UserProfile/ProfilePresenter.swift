import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private let profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        updateProfileDetails()
        updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setProfileAvatar(with: url)
    }
    
    private func updateProfileDetails() {
        view?.setProfileDetails(profile: profileService.profile)
    }
}

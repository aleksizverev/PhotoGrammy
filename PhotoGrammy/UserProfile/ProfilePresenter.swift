import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func updateProfileDetails()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private let profileService = ProfileService.shared
    weak var view: ProfileViewControllerProtocol?
    var profileSetUpHelper: ProfileSetUpHelperProtocol
    
    init(profileSetUpHelper: ProfileSetUpHelperProtocol) {
        self.profileSetUpHelper = profileSetUpHelper
    }
    
    func viewDidLoad() {
        updateProfileDetails()
        updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let url = profileSetUpHelper.getUserProfileAvatarURL()
        else { return }
        view?.setProfileAvatar(with: url)
    }
    
    func updateProfileDetails() {
        view?.setProfileDetails(profile: profileService.profile)
    }
}

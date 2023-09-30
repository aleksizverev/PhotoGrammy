import UIKit

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func updateProfileDetails()
    func didTapExitButton()
    func createAlert(with alertModel: AlertModel) -> UIAlertController
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private let oauth2TokenStorage = OAuth2TokenStorage()
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
    
    func didTapExitButton(){
        let alert = createAlert(
            with: AlertModel(
                title: "Goodbye!",
                message: "Are you sure you want to exit?",
                buttonText: "")
        )
        view?.showAlert(alert: alert)
    }
    
    func createAlert(with alertModel: AlertModel) -> UIAlertController {
        var alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let actionYes = UIAlertAction(
            title: "Yes",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.exitFromProfile()
            }
        
        let actionNo = UIAlertAction(
            title: "No",
            style: .cancel) { _ in
                alert.dismiss(animated: true)
            }
        alert = addActionsToAlert(alert: alert, actions: [actionYes, actionNo])
        return alert
    }
    
    private func exitFromProfile() {
        WebViewViewController.clean()
        oauth2TokenStorage.cleanStorage()
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Inavalid configuration")
        }
        window.rootViewController = SplashScreenViewController()
    }
    
    private func addActionsToAlert(
        alert: UIAlertController,
        actions: [UIAlertAction]?) -> UIAlertController {
            actions?.forEach { action in
                alert.addAction(action)
            }
            return alert
    }
}

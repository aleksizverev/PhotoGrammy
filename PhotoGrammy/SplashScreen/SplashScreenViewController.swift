import UIKit
import ProgressHUD

final class SplashScreenViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauthService = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var splashScreenLogoImageView: UIImageView = {
        let image = UIImage(named: "SplashScreenLogo")
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = UIColor(named: "YP Black")
        addSubviews()
        applyConstraints()
        
        if let token = OAuth2TokenStorage().token {
            fetchProfile(token: token)
        } else {
            presentAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func addSubviews() {
        view.addSubview(splashScreenLogoImageView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            splashScreenLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashScreenLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.windows.first else {fatalError("Invalid Configuration")}
        
        // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
    
    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
        guard let authVC = VC as? AuthViewController else { return }
        
        authVC.delegate = self
        authVC.modalPresentationStyle = .fullScreen
        
        present(authVC, animated: true, completion: nil)
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            self.oauthService.fetchOAuthToken(code) { result in
                switch result {
                case .success(let token):
                    self.fetchProfile(token: token)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlert(on: self,
                              alertModel: AlertModel(
                                title: "Something went wrong",
                                message: "Unable to login",
                                buttonText: "Ok"))
                }
            }
        }
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { result in
            switch(result) {
            case .success(let profile):
                UIBlockingProgressHUD.dismiss()
                self.profileImageService.fetchProfileImageURL(
                    username: profile.username,
                    token: token) { _ in }
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert(on: self,
                          alertModel: AlertModel(
                            title: "Something went wrong",
                            message: "Unable to login",
                            buttonText: "Ok"))
            }
        }
    }
}

// MARK: - AlertsPresentation
extension SplashScreenViewController {
    private func showAlert(on controller: UIViewController, alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in
                self.presentAuthViewController()
            }
        
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
}

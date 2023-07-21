import UIKit

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    
    private var profileImageView: UIImageView = {
        let image = UIImage(named: "UserPic")
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ekaterina Novikova"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var userTagLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exitButton: UIButton = {
        let exitButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapExitButton))
        exitButton.tintColor = .red
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = profileService.profile {
            setUpUserProfile(profile: profile)
        }
        addSubviews()
        applyConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc
    private func didTapExitButton() {
        nameLabel.removeFromSuperview()
        userTagLabel.removeFromSuperview()
        userDescriptionLabel.removeFromSuperview()
    }
    
    private func setUpUserProfile(profile: Profile){
        nameLabel.text = profile.name
        userTagLabel.text = profile.loginName
        userDescriptionLabel.text = profile.bio
    }
    
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(userTagLabel)
        view.addSubview(userDescriptionLabel)
        view.addSubview(exitButton)
    }
    
    private func applyConstrains() {
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            userTagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            userTagLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            userDescriptionLabel.topAnchor.constraint(equalTo: userTagLabel.bottomAnchor, constant: 8),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: userTagLabel.leadingAnchor),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44) ])
    }
}

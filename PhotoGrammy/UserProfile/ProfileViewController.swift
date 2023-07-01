import UIKit

final class ProfileViewController: UIViewController {
    private var profileImage = UIImage(named: "UserPic")
    private var imageView = UIImageView()
    
    private var nameLabel = UILabel()
    private var userTagLabel = UILabel()
    private var userDescriptionLabel = UILabel()
    
    let exitButton = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!,
                                           target: self,
                                           action: #selector(Self.didTapExitButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        constrain()
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
    
    private func configure() {
        imageView.image = profileImage
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Ekaterina Novikova"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userTagLabel.text = "@ekaterina_nov"
        userTagLabel.textColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.0)
        userTagLabel.font = UIFont.systemFont(ofSize: 13.0)
        userTagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userDescriptionLabel.text = "Hello, world!"
        userDescriptionLabel.textColor = .white
        userDescriptionLabel.font = UIFont.systemFont(ofSize: 13.0)
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        exitButton.tintColor = .red
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
    }
    
    private func constrain() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(userTagLabel)
        view.addSubview(userDescriptionLabel)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            
            userTagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            userTagLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            userDescriptionLabel.topAnchor.constraint(equalTo: userTagLabel.bottomAnchor, constant: 8),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: userTagLabel.leadingAnchor),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44) ])
    }
}

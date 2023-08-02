import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "TabProfileActive"),
            selectedImage: nil)
        
        self.tabBar.standardAppearance.backgroundColor = UIColor(named: "YP Black")
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

import UIKit

final class SingleImageViewController: UIViewController {
    private var image: UIImage!
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    func setCurrentImage(to image: UIImage!){
        self.image = image
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
}


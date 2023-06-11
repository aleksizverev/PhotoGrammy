import UIKit

final class ImagesListViewController: UIViewController {
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet private var imageListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageListTableView.dataSource = self
        imageListTableView.delegate = self
        imageListTableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageListTableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageName = String(indexPath.row)
        guard let image = UIImage(named: imageName) else {
            return 0
        }
        
        let imageWidth = image.size.width
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = imageListTableView.bounds.width - imageInsets.left - imageInsets.right
        let ratio = imageViewWidth/imageWidth
        
        return image.size.height * ratio + imageInsets.top + imageInsets.bottom
    }
}

// MARK: - UITableViewCellConfig
extension ImagesListViewController {
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = String(indexPath.row)
        guard let image = UIImage(named: imageName) else {
            return
        }
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let likeButtonImage = indexPath.row % 2 == 0 ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff")
        cell.likeButton.setImage(likeButtonImage, for: .normal)
    }
}

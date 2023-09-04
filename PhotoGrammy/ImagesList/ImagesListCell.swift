import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func configure(for model: ImagesListCellModel) {
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: model.imageURL,
            placeholder: UIImage(named: "Stub.png")) { _ in model.completion() }
        dateLabel.text = model.date
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeButtonImage = isLiked ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff")
        likeButton.setImage(likeButtonImage, for: .normal)
    }
}

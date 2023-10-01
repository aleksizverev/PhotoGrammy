import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func setCellIsLiked(indexPath: IndexPath)
    func updateTableViewAnimated(indexPaths: [IndexPath])
    func reloadRows(at indexPath: IndexPath)
    func showProgressHUD()
    func hideProgressHUD()
    func configure(_ presenter: ImagesListPresenterProtocol)
    func setUpTableView()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var presenter: ImagesListPresenterProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var imageListTableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: .didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                presenter?.didUpdatePhotosList()
                UIBlockingProgressHUD.dismiss()
            }
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .didChangeNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as? IndexPath
            guard
                let indexPath = indexPath,
                let photo = presenter?.photos[indexPath.row]
            else {
                assertionFailure("Error preparing single image segue")
                return
            }
            let url = URL(string: photo.largeImageURL)
            viewController.imageURL = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func setUpTableView() {
        imageListTableView.delegate = self
        imageListTableView.dataSource = self
        imageListTableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func updateTableViewAnimated(indexPaths: [IndexPath]) {
        //        presenter?.didUpdatePhotosList()
        imageListTableView.performBatchUpdates {
            imageListTableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func reloadRows(at indexPath: IndexPath) {
        imageListTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showProgressHUD() {
        UIBlockingProgressHUD.show()
    }
    
    func hideProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photos = presenter?.photos else {
            return 0
        }
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageListTableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        presenter?.configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photos = presenter?.photos else {
            return 0
        }
        let cell = photos[indexPath.row]
        let ratio = cell.size.width/cell.size.height
        return tableView.frame.width/ratio
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let
            visibleRows = imageListTableView.indexPathsForVisibleRows,
            indexPath == visibleRows.last {
            presenter?.willUpdatePhotosList(for: indexPath.row)
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = imageListTableView.indexPath(for: cell) else { return }
        presenter?.updatePhotoLikeState(for: indexPath)
    }
    
    func setCellIsLiked(indexPath: IndexPath) {
        guard
            let cell = imageListTableView.cellForRow(at: indexPath) as? ImagesListCell,
            let photos = presenter?.photos
        else { return }
        cell.setIsLiked(isLiked: photos[indexPath.row].isLiked)
    }
}

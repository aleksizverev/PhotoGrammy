import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func viewDidLoad()
    func didUpdatePhotosList()
    func willUpdatePhotosList(for photoNumber: Int)
    func updatePhotoLikeState(for indexPath: IndexPath)
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private let imagesListService = ImageListService.shared
    var photos: [Photo] = []
    
    private lazy var isoFormatter: ISO8601DateFormatter = .init()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_GB")
        return formatter
    }()
    
    weak var view: ImagesListViewControllerProtocol?
    
    var currentPhotosList: [Photo] {
        photos
    }
    
    init(view: ImagesListViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showProgressHUD()
        view?.setUpTableView()
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func willUpdatePhotosList(for photoNumber: Int) {
        if photoNumber + 1 == imagesListService.photos.count {
            fetchPhotosNextPage()
        }
    }
    
    func didUpdatePhotosList() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.updateTableViewAnimated(indexPaths: indexPaths)
        }
    }
    
    func updatePhotoLikeState(for indexPath: IndexPath) {
    
        let photo = photos[indexPath.row]
        
        view?.showProgressHUD()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) {
            [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                view?.setCellIsLiked(indexPath: indexPath)
                view?.hideProgressHUD()
                
            case .failure:
                view?.hideProgressHUD()
            }
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let imageURL = photos[indexPath.row].thumbImageURL
        guard let url = URL(string: imageURL) else { return }
        
        var dateCreated = ""
        if let createdAt = photos[indexPath.row].createdAt,
           let date = isoFormatter.date(from: createdAt) {
            dateCreated = dateFormatter.string(from: date)
        }
        
        let model = ImagesListCellModel(
            imageURL: url,
            date: dateCreated) { [weak self] in
                guard let self = self else { return }
                view?.reloadRows(at: indexPath)
            }
        
        cell.configure(for: model)
        cell.setIsLiked(isLiked: photos[indexPath.row].isLiked)
    }
}


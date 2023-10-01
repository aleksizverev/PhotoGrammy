@testable import PhotoGrammy
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var photos: [PhotoGrammy.Photo] = []
    var view: PhotoGrammy.ImagesListViewControllerProtocol?
    var presenter: PhotoGrammy.ImagesListPresenterProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {}
    
    func didUpdatePhotosList() {}
    
    func willUpdatePhotosList(for photoNumber: Int) {}
    
    func updatePhotoLikeState(for indexPath: IndexPath) {}
    
    func getCurrentPhotosList() -> [PhotoGrammy.Photo] {
        return [Photo(id: "1",
                      size: CGSize(width: 20, height: 30),
                      createdAt: "07-01-2000",
                      welcomeDescription: "Hello, world!",
                      thumbImageURL: "test_thumb_url.com",
                      largeImageURL: "large_thumb_url.com",
                      isLiked: true)]
    }
    
    func configCell(for cell: PhotoGrammy.ImagesListCell, with indexPath: IndexPath) {}
}

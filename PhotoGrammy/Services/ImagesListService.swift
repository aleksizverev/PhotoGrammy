import Foundation

final class ImageListService {
    static let shared = ImageListService()
    
    private(set) var photos: [Photo] = []
    private(set) var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let session = URLSession.shared
    
    func fetchPhotosNextPage() {
        let pageToLoad = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1

        task?.cancel()
        var request = imageListRequest(page: String(pageToLoad))
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "")",
                         forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) { [weak self]
            (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photosResults):
                    let photos = photosResults.map { Photo(photoResult: $0) }
                    self.photos.append(contentsOf: photos)
                    self.lastLoadedPage = pageToLoad
                    
                    NotificationCenter.default.post(
                        name: .didChangeNotification,
                        object: self,
                        userInfo: ["photos" : self.photos])
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String,
                    isLike: Bool,
                    _ completion: @escaping (Result<Void, Error>) -> Void) {
        task?.cancel()
        
        var request = isLike == true
        ? likeImageRequest(id: photoId)
        : deleteLikeRequest(id: photoId)
        
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "")",
                         forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) {[weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked)
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

extension ImageListService {
    private func imageListRequest(page: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path:"/photos?page=\(page)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
    }
    
    private func likeImageRequest(id: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "/photos/\(id)/like",
            httpMethod: "POST")
    }
    private func deleteLikeRequest(id: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "/photos/\(id)/like",
            httpMethod: "DELETE")
    }
}

import Foundation

final class ImageListService {
    static let shared = ImageListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private(set) var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let session = URLSession.shared
    
    func fetchPhotosNextPage() {
        let pageToLoad = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        print("TRYING TO FETCH PAGE NUMBER \(pageToLoad)")

        task?.cancel()
        var request = imageListRequest(page: String(pageToLoad))
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "")", forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) {
            (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let photosResults):
                    print("SUCCESS")
                    
                    let photos = photosResults.map { Photo(photoResult: $0) }
                    self.photos.append(contentsOf: photos)
                    self.lastLoadedPage = pageToLoad
                    
                    NotificationCenter.default.post(
                        name: ImageListService.DidChangeNotification,
                        object: self,
                        userInfo: ["photos" : self.photos])
                case .failure:
                    print("ERROR LOADING PHOTOS")
                }
                self.task = nil
            }
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
}

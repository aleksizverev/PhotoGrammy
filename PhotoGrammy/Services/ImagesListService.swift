import Foundation

final class ImageListService {
    static let shared = ImageListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private(set) var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let session = URLSession.shared
    
    func fetchPhotosNextPage() {
        print("TRYING TO FETCH..")
        let pageToLoad = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        task?.cancel()
        var request = imageListRequest()
        request.setValue(String(pageToLoad), forHTTPHeaderField: "page")
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "")", forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) {
            (result: Result<[PhotoResult], Error>) in
            
            switch result {
            case .success(let photosResults):
                print("SUCCESS")
                DispatchQueue.main.async {
                    photosResults.forEach { photoResult in
                        self.photos.append(Photo(photoResult: photoResult))
                    }
                    self.lastLoadedPage = pageToLoad
                    
                    NotificationCenter.default.post(
                        name: ImageListService.DidChangeNotification,
                        object: self)
                }
            case .failure:
                print("ERROR LOADING PHOTOS")
            }
        }
        self.task = task
        task.resume()
    }
}

extension ImageListService {
    private func imageListRequest() -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path:"/photos",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
    }
}

import Foundation

final class ImageListService {
    static let shared = ImageListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let session = URLSession.shared
    
    func fetchPhotosNextPage() {
        let pageToLoad = lastLoadedPage == nil ? "1" : String(lastLoadedPage! + 1)
        
        task?.cancel()
        var request = imageListRequest()
        request.setValue(pageToLoad, forHTTPHeaderField: "page")
        
        let task = session.objectTask(for: request) {
            (result: Result<PhotoResults, Error>) in
            
            switch result {
            case .success(let photosResults):
                photosResults.results.forEach { photoResult in
                    self.photos.append(Photo(photoResult: photoResult))
                }
            case .failure:
                print("Error loading photos")
            }
        }
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

import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    enum ImageFetchErrors: Error {
        case NoUserImageFound
    }
    
    func fetchProfileImageURL(
        username: String,
        token: String,
        _ completion: @escaping (Result<String, Error>) -> Void) {
            assert(Thread.isMainThread)
            task?.cancel()
            
            var request = userProfileImageRequest(username: username)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = session.objectTask(for: request) { (result: Result<UserResult, Error>) in
                
                switch result {
                case .success(let userResult):
                    guard
                        let avatarURL = userResult.profileImage?.small else {
                        completion(.failure(ImageFetchErrors.NoUserImageFound))//TODO: redo this
                        return
                    }
                    
                    completion(.success(avatarURL))
                    NotificationCenter.default.post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                    
                    self.avatarURL = avatarURL
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            self.task = task
            task.resume()
        }
}

extension ProfileImageService {
    private func userProfileImageRequest(username: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path:"/users/\(username)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
    }
}

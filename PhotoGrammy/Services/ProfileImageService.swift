import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangedNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private var task: URLSessionTask?
    private var session = URLSession.shared
    private(set) var avatarURL: String?
    
    func fetchProfileImageURL(
        username: String,
        token: String,
        _ completion: @escaping (Result<String, Error>) -> Void) {
            assert(Thread.isMainThread)
            task?.cancel()
            
            var request = userImageRequest(username: username)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = session.objectTask(for: request) { [weak self]
                (result: Result<UserResult, Error>) in
                
                switch result {
                case .success(let userResult):
                    let avatarURL = userResult.profileImage.medium
                    completion(.success(avatarURL))
                    self?.avatarURL = avatarURL // how to unwrap self correctly here?
                    self?.task = nil
                    NotificationCenter.default.post(
                        name: ProfileImageService.DidChangedNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            self.task = task
            task.resume()
        }
}

extension ProfileImageService {
    private func userImageRequest(username: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path:"/users/\(username)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
    }
}

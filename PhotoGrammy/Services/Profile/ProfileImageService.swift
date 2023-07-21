import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    
    private let profileService = ProfileService.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void) {
            assert(Thread.isMainThread)
            
            task?.cancel()
            
            var request = userProfileImageRequest()
            request.setValue("Bearer \(OAuth2Service().authToken)", forHTTPHeaderField: "Authorization")
            
            let task = object(for: request) { result in
                switch result {
                case .success(let avatarURL):
                    completion(.success(avatarURL))
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
    private func userProfileImageRequest() -> URLRequest {
            return URLRequest.makeHTTPRequest(
                path:"/users/\(profileService.getProfileUsername())",
                httpMethod: "GET",
                baseURL: DefaultBaseURL)
        }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<String, Error>) -> Void
    ) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        
        return urlSession.data(for: request) { (result: Result<Data, Error>) in

            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(
                        UserResult.self,
                        from: data
                    )
                    completion(.success(object.profileImage?["small"] ?? "")) //TODO: optional type handle??
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

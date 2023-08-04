import UIKit

final class ProfileService {
    static let shared = ProfileService()
    
    private let session = URLSession.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void) {
            assert(Thread.isMainThread)
            task?.cancel()
            
            var request = userProfileRequest()
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = session.objectTask(for: request) {
                (result: Result<ProfileResult, Error>) in
                
                switch result {
                case .success(let profileResult):
                    let profile = Profile(profileResult: profileResult)
                    completion(.success(profile))
                    self.profile = profile
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            self.task = task
            task.resume()
        }
    
    func getProfileUsername() -> String {
        guard let profileUsername = profile?.username else {
            return "" //TODO: change this
        }
        return profileUsername
    }
}

extension ProfileService {
    private func userProfileRequest() -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path:"/me",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
    }
}

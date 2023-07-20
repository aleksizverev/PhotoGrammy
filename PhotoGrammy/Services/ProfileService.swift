import UIKit

final class ProfileService {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void) {
            assert(Thread.isMainThread)
            
            task?.cancel()
            
            var request = userProfileRequest()
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = object(for: request) { result in
                switch result {
                case .success(let body):
                    completion(.success(body))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            self.task = task
            task.resume()
            
        }
}

extension ProfileService {
    private func userProfileRequest() -> URLRequest {
            return URLRequest.makeHTTPRequest(
                path:"/me",
                httpMethod: "GET",
                baseURL: DefaultBaseURL)
        }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        
        return urlSession.data(for: request) { (result: Result<Data, Error>) in

            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(
                        ProfileResult.self,
                        from: data
                    )
                    completion(.success(Profile(profileResult: object)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

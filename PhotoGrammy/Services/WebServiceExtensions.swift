import Foundation

extension JSONDecoder {
    func decodeGenericType<T: Decodable>(
        data: Data,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            let decoder = JSONDecoder()
            
            do {
                let object = try decoder.decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
}

extension URLRequest {
    static func makeHTTPRequest(path: String,
                                httpMethod: String,
                                baseURL: URL = DefaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}

extension URLSession {
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async{
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { [weak self] data, response, error in
            
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    guard let self = self else { return }
                    let decodedData =  JSONDecoder().decodeGenericType(data: data, completion: fulfillCompletion)
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        
        task.resume()
        return task
    }
}

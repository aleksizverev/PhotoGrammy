import Foundation

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
        
        let task = dataTask(with: request) { data, response, error in
            
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    JSONDecoder().decode(data: data, completion: fulfillCompletion)
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                    print("STATUS CODE: \(statusCode)")
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                print("URL REQUEST ERROR")
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
                print("URL SESSION ERROR")
            }
        }
        task.resume()
        return task
    }
}

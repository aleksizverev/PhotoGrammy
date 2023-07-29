import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(
        data: Data,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            let decoder = JSONDecoder()
            
            do {
                let object = try decoder.decode(
                    T.self,
                    from: data
                )
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
}

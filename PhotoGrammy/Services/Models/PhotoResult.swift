struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let created_at: String?
    let description: String?
    let urls: UrlsResult
    let liked_by_user: Bool?
}

struct UrlsResult: Codable {
    let thumb: String
    let full: String
}

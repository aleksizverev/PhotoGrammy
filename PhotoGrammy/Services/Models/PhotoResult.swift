struct PhotoResults: Codable {
    let results: [PhotoResult]
}

struct PhotoResult: Codable {
    let id: String
    let created_at: String
    let description: String
    let urls: ImageURLS
    let liked_by_user: Bool
}

struct ImageURLS: Codable {
    let thumb: String
    let full: String
}

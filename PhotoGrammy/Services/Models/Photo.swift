import Foundation

struct Photo {
    let id: String
//    let size: CGSize
    let createdAt: String? // Should be Date type
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(photoResult: PhotoResult) {
        id = photoResult.id
//        size = photoResult.size
        createdAt = photoResult.created_at
        welcomeDescription = photoResult.description
        thumbImageURL = photoResult.urls.thumb
        largeImageURL = photoResult.urls.full
        isLiked = photoResult.liked_by_user
    }
}

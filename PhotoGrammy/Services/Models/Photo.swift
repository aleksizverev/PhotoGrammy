import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String   
    let isLiked: Bool?
    
    init(photoResult: PhotoResult) {
        id = photoResult.id
        size = CGSize(width: photoResult.width, height: photoResult.height)
        
        let dateFormatter = 	DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        createdAt = 	dateFormatter.date(from: photoResult.created_at ?? "")
        
        welcomeDescription = photoResult.description
        thumbImageURL = photoResult.urls.thumb
        largeImageURL = photoResult.urls.full
        isLiked = photoResult.liked_by_user
    }
}

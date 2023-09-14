import Foundation

extension Array {
    func withReplaced(itemAt: Int, newValue: Photo) -> [Photo]{
        var photos = ImageListService.shared.photos
        photos.replaceSubrange(itemAt...itemAt, with: [newValue])
        return photos
    }
}

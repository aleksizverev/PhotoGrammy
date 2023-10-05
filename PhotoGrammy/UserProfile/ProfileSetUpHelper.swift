import Foundation

protocol ProfileSetUpHelperProtocol {
    func getUserProfileAvatarURL() -> URL?
}

final class ProfileSetUpHelper: ProfileSetUpHelperProtocol {
    private var profileImageService = ProfileImageService.shared

    func getUserProfileAvatarURL() -> URL? {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
}

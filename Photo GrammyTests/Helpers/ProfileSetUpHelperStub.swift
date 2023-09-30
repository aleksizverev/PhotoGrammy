@testable import PhotoGrammy
import Foundation

final class ProfileSetUpHelperStub: ProfileSetUpHelperProtocol {
    
    func getUserProfileAvatarURL() -> URL? {
        let testURL = URL(string: "test_url.com")
        return testURL
    }
}

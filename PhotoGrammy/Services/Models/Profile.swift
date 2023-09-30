import Foundation

public struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    public init(username: String, name: String, loginName: String, bio: String) {
        self.username = username
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
}

//MARK: - ProfileResultInit
extension Profile {
    init(profileResult: ProfileResult) {
        username =  profileResult.username ?? ""
        name =  "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")"
        loginName =  "@\(profileResult.username ?? "")"
        bio = profileResult.bio ?? ""
    }
}

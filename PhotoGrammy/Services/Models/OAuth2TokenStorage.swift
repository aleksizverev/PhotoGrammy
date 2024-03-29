import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    var token: String? {
        get { KeychainWrapper.standard.string(forKey: "token") }
        set { KeychainWrapper.standard.set(newValue ?? "", forKey: "token") }
    }
    
    func cleanStorage() {
        KeychainWrapper.standard.removeAllKeys()
    }
}

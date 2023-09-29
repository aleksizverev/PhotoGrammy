import PhotoGrammy
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: PhotoGrammy.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}

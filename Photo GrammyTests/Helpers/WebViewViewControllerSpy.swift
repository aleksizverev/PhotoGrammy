@testable import PhotoGrammy
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: PhotoGrammy.WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
    
    
}

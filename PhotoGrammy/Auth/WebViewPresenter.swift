import UIKit

public protocol WebViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    private var authConfiguration = AuthConfiguration.standard
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        view?.setProgressHidden(shouldHideProgress(for: newProgressValue))
    }
    
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1) <= 0.0001
    }
}

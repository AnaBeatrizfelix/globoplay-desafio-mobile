import Foundation

protocol SplashPresentationLogic: AnyObject {
    func presentNextScreen(_ response: SplashModels.Load.Response)
}

final class SplashPresenter: SplashPresentationLogic {
    weak var viewController: SplashDisplayLogic?

    func presentNextScreen(_ response: SplashModels.Load.Response) {
        DispatchQueue.main.async {
            self.viewController?.displayNextScreen(SplashModels.Load.ViewModel())
        }
    }
}

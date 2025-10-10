import Foundation

protocol SplashBusinessLogic {
    func loadApp(_ request: SplashModels.Load.Request)
}

final class SplashInteractor: SplashBusinessLogic {
    var presenter: SplashPresentationLogic?
    var worker = SplashWorker()

    func loadApp(_ request: SplashModels.Load.Request) {
        Task {
            await worker.simulateLoading()
            presenter?.presentNextScreen(SplashModels.Load.Response())
        }
    }
}

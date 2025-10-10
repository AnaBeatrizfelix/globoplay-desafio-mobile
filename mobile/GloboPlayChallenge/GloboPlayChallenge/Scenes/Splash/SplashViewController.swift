import UIKit

protocol SplashDisplayLogic: AnyObject {
    func displayNextScreen(_ viewModel: SplashModels.Load.ViewModel)
}

final class SplashViewController: UIViewController, SplashDisplayLogic {

    // VIP
    var interactor: SplashBusinessLogic?

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logoGP")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        setupVIP()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupVIP() {
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
        self.interactor = interactor
    }

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        interactor?.loadApp(.init())
    }

    private func setupLayout() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - Display
    func displayNextScreen(_ viewModel: SplashModels.Load.ViewModel) {
        let tabBar = MainTabBarViewController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
}

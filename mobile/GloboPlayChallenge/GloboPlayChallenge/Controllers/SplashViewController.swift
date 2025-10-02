import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.image = UIImage(named: "logoGP")
           imageView.contentMode = .scaleAspectFit
           return imageView
       }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
               setupLayout()
        navigateToMainTab()
        
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
    private func navigateToMainTab() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let tabBar = MainTabBarViewController()
            tabBar.modalPresentationStyle = .fullScreen
            self.present(tabBar, animated: true)
        }
    }
}

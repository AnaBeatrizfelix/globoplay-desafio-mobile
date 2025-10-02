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
               navigateToMovies()
        
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
    private func navigateToMovies() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let vc = MovieListViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
}

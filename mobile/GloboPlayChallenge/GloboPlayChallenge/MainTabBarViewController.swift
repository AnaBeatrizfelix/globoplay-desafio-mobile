import UIKit

final class MainTabBarViewController: UITabBarController {

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTabs()
    }

    // MARK: - Aparência
    private func setupAppearance() {
        view.backgroundColor = .black

        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray

        // Adiciona uma sombra sutil no topo do tab bar
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 6
    }

    // MARK: - Configuração das abas
    private func setupTabs() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let favoritesVC = UINavigationController(rootViewController: FavoriteMoviesViewController())

        // Ícones do sistema
        homeVC.tabBarItem = UITabBarItem(
            title: "Início",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        favoritesVC.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        // Define os controladores
        setViewControllers([homeVC, favoritesVC], animated: false)
    }
}

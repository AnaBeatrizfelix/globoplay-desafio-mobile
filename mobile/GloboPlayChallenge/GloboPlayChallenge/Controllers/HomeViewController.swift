//
//  HomeViewController.swift
//  GloboPlayChallenge
//
//  Created by ana on 01/10/25.
//

import UIKit

enum Sections: Int {
    case novelas = 0
    case series = 1
    case cinema = 2
}

class HomeViewController: UIViewController {
    
    
    
    let sectionTitles: [String] = ["Novelas", "Séries", "Cinema"]
    
    
    private let homeFeedtable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        view.addSubview(homeFeedtable)
        
        homeFeedtable.delegate = self
        homeFeedtable.dataSource = self
        configureHeaderLogo()

    }
    
    private func configureHeaderLogo() {
        guard let logoImage = UIImage(named: "logoGP") else {
            print("Logo não encontrada.")
            return
        }

        let headerHeight: CGFloat = 50
        let headerView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: headerHeight
        ))

        let whiteColor = logoImage.withRenderingMode(.alwaysTemplate)
        let logoImageView = UIImageView(image: whiteColor)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = .white
        logoImageView.clipsToBounds = true

      
        let logoWidth: CGFloat = 300
        let logoHeight: CGFloat = 270
        logoImageView.frame = CGRect(
            x: (headerView.frame.width - logoWidth) / 2,
            y: (headerHeight - logoHeight) / 2 + 5,
            width: logoWidth,
            height: logoHeight
        )

        headerView.addSubview(logoImageView)
        homeFeedtable.tableHeaderView = headerView
       
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedtable.frame = view.bounds
    }
    
}
//MARK: - UITableview Delegate e DataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case Sections.novelas.rawValue:
            Task {
                do {
                    let novelas = try await MovieService().getPopularNovelas()
                    cell.configure(with: novelas)
                } catch {
                    print("Erro Novelas:", error.localizedDescription)
                }
            }
            
        case Sections.series.rawValue:
            Task {
                do {
                    let series = try await MovieService().getPopularSeries()
                    cell.configure(with: series)
                } catch {
                    print("Erro Séries:", error.localizedDescription)
                }
            }
            
        case Sections.cinema.rawValue:
            Task {
                do {
                    let movies = try await MovieService().getPopularMovies()
                    cell.configure(with: movies)
                } catch {
                    print("Erro Cinema:", error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection indexPath:Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizerFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

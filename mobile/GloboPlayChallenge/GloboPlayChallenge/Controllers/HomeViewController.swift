//
//  HomeViewController.swift
//  GloboPlayChallenge
//
//  Created by ana on 01/10/25.
//

import UIKit

enum Sections: Int {
    case cinema = 0
    case series = 1
    case novelas = 2
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
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedtable)
        
        homeFeedtable.delegate = self
        homeFeedtable.dataSource = self
        
        configureNavBar()
    }
    
    private func configureNavBar() {
        
        guard let image = UIImage(named: "logoGP") else { return }
        
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 120, height: 110))
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: resizedImage, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedtable.frame = view.bounds
    }
    
}

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
            case Sections.cinema.rawValue:
                Task {
                    do {
                        let movies = try await MovieService().getPopularMovies()
                        cell.configure(with: movies)
                    } catch {
                        print("Erro Cinema:", error.localizedDescription)
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
                
            case Sections.novelas.rawValue:
                Task {
                    do {
                        let novelas = try await MovieService().getDiscoverTV()
                        cell.configure(with: novelas)
                    } catch {
                        print("Erro Novelas:", error.localizedDescription)
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

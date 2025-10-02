import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate {
    
    private var movies: [Movie] = []
    private let movieService = MovieService()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Filmes Populares"
        
        addSubviews()
        setupConstraints()
        setupTableView()
        
        Task {
            await fetchMovies()
        }
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: "MovieListTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Fetch API
    private func fetchMovies() async {
        do {
            movies = try await movieService.getMovies()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieListTableViewCell",
            for: indexPath
        ) as? MovieListTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        let title = movie.title
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")
        
        let placeholder = UIImage(systemName: "film")
        
        if let data = try? Data(contentsOf: posterURL!), let image = UIImage(data: data) {
            cell.configure(title: title, image: image)
        } else {
            cell.configure(title: title, image: placeholder)
        }
        
        return cell
    }
}

func tableView(_tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 160
}


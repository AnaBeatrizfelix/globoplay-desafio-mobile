import UIKit

// MARK: - Display Protocol
protocol HomeDisplayLogic: AnyObject {
    func displayHomeSections(_ viewModel: HomeModels.FetchSections.ViewModel)
}

final class HomeViewController: UIViewController,
                                HomeDisplayLogic,
                                UITableViewDelegate,
                                UITableViewDataSource {
    
    // VIP
    var interactor: HomeBusinessLogic?
    private var viewModel: HomeModels.FetchSections.ViewModel?
    private var sections: [HomeModels.SectionViewModel] = []
    
    // MARK: - UI
    private let sectionTitles: [String] = ["Novelas", "Séries", "Cinema"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self,
                       forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.backgroundColor = .clear
        return table
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        interactor.presenter = presenter
        presenter.viewController = self
        self.interactor = interactor
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        configureHeaderLogo()
        interactor?.fetchHomeSections(.init())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    // MARK: - Display
    func displayHomeSections(_ viewModel: HomeModels.FetchSections.ViewModel) {
        self.viewModel = viewModel
        self.sections = viewModel.sections
        homeFeedTable.reloadData()
    }
    
    // MARK: - Header
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
        
        let logoWidth: CGFloat = 280
        let logoHeight: CGFloat = 250
        logoImageView.frame = CGRect(
            x: (headerView.frame.width - logoWidth) / 2,
            y: (headerHeight - logoHeight) / 2 + 5,
            width: logoWidth,
            height: logoHeight
        )
        
        headerView.addSubview(logoImageView)
        homeFeedTable.tableHeaderView = headerView
    }
    
    // MARK: - Table Delegate/DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionTableViewCell.identifier,
            for: indexPath
        ) as? CollectionTableViewCell else {
            return UITableViewCell()
        }
        
        let section = sections[indexPath.section]
        
        cell.configure(with: section.items, parentViewController: self)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(
            x: header.bounds.origin.x + 20,
            y: header.bounds.origin.y,
            width: 100,
            height: header.bounds.height
        )
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.lowercased()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(
            translationX: 0,
            y: min(0, -offset)
        )
    }
}

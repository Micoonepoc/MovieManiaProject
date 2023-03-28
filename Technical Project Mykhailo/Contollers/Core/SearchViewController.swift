import UIKit

class SearchViewController: UIViewController {

    
    private var titles: [Movie] = [Movie]()
    private var testTitles: [TestModel] = [TestModel]()

    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search..."
        controller.searchBar.searchBarStyle = .default
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"

        view.backgroundColor = .systemBackground
        
        view.addSubview(searchTable)
        searchTable.delegate = self
        searchTable.dataSource = self
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
        
        searchTable.separatorStyle = .none

    }

    private func fetchDiscoverMovies() {
        NetworkService.shared.discoverMovie { [weak self] result in
                self?.titles = result
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        
        let title = titles[indexPath.row]
        let model = TitleModel(titleName: title.original_title ?? "", posterURL: title.poster_path ?? "", overview: title.overview ?? "", rating: title.vote_average)
        cell.configure(with: model)
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title else {
            return
        }
        
        
        NetworkService.shared.getYouTubeResponse(with: titleName + " trailer") { [weak self] result in
                DispatchQueue.main.async {
                    let vc = PreviewViewController()
                    vc.configure(with: PreviewModel(title: titleName, youtubeVideo: result, titleOverView: title.overview ?? "", rating: Double(title.vote_average), vote_count: title.vote_count))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
                  return
              }
        resultsController.delegate = self
        
        NetworkService.shared.searchTestAF(with: query) { result in
            DispatchQueue.main.async {

                resultsController.testTitles = result;
                resultsController.searchResultsCollectionView.reloadData()

            }
        }
        
    }
    func searchResultsViewControllerDidTapItem(_ viewModel: PreviewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

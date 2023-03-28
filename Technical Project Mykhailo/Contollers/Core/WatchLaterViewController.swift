import UIKit


class WatchLaterViewController: UIViewController {
    
    var movies = [MovieItem]()

    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Movies", "TV Shows"])
        
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .red
        sc.layer.cornerRadius = 120
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    var movie = true

    private var titles: [MovieItem] = [MovieItem]()
    private var tvTitles: [TvItem] = [TvItem]()

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        let frame = self.navigationController?.navigationBar.bounds ?? CGRect.zero
             segmentedControl.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
             self.navigationItem.titleView = segmentedControl
       
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
        
        view.addSubview(tableView)
        tableView.register(WatchLaterTableViewCell.self, forCellReuseIdentifier: WatchLaterTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        view.addSubview(segmentedControl)
        applyConstraints()
        
    }
    
    @objc func handleSegmentChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Movies segment selected")
            movie = true
            tableView.reloadData()

        case 1:
            print("TV Shows segment selected")
            movie = false
            tableView.reloadData()
        default:
            break
        }
    }
    
    func applyConstraints() {
           segmentedControl.translatesAutoresizingMaskIntoConstraints = false
           segmentedControl.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
           segmentedControl.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
           segmentedControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
           segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
       }

    private func fetchLocalStorageForDownload() {
        switch movie {
            
        case true:
            DataPersistenceManager.shared.fetchingMoviesFromDataBase { [weak self] result in
                switch result {
                case .success(let titles):
                    self?.titles = titles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            tableView.reloadData()
        case false:
            DataPersistenceManager.shared.fetchingTvFromDataBase { [weak self] result in
                switch result {
                case .success(let titles):
                    self?.tvTitles = titles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension WatchLaterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch movie {
            
        case true:
            return titles.count
        case false:
            return tvTitles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchLaterTableViewCell.identifier, for: indexPath) as? WatchLaterTableViewCell else {
            return UITableViewCell()
        }
        switch movie {
            
        case true:
            let title = titles[indexPath.row]
            cell.configure(with: TitleModel(titleName: title.original_title ?? "", posterURL: title.poster_path ?? "", overview: title.overview ?? "", rating: title.vote_average))
        case false:
            let title = tvTitles[indexPath.row]
            cell.configure(with: TitleModel(titleName: title.name ?? "", posterURL: title.poster_path ?? "", overview: title.overview ?? "", rating: title.vote_average))
        }
        return cell
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:

            switch movie {
                
            case true:
                DataPersistenceManager.shared.deleteMovieWith(model: titles[indexPath.row]) { [weak self] result in
                    switch result {
                    case .success():
                        print("deleted")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self?.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            case false:
                DataPersistenceManager.shared.deleteTvWith(model: tvTitles[indexPath.row]) { [weak self] result in
                    switch result {
                    case .success():
                        print("deleted")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self?.tvTitles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch movie {
            
        case true:
            let title = titles[indexPath.row]
            
            guard let titleName = title.original_title else {
                return
            }
            
            NetworkService.shared.getYouTubeResponse(with: titleName) { [weak self] result in
                
                DispatchQueue.main.async {
                    let vc = PreviewViewController()
                    vc.configure(with: PreviewModel(title: titleName, youtubeVideo: result, titleOverView: title.overview ?? "", rating: title.vote_average , vote_count: Int(title.vote_count)))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        case false:
            let title = tvTitles[indexPath.row]
            
            guard let titleName = title.name else {
                return
            }

            NetworkService.shared.getYouTubeResponse(with: titleName) { [weak self] result in
                DispatchQueue.main.async {
                    let vc = PreviewViewController()
                    vc.configure(with: PreviewModel(title: titleName, youtubeVideo: result, titleOverView: title.overview ?? "", rating: title.vote_average , vote_count: Int(title.vote_count)))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}





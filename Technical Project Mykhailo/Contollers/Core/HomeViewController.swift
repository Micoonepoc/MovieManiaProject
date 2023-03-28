
import UIKit
import CoreData


enum Sections: Int {
    case TopRated = 0
    case Popular = 1
    case Upcoming = 2
}

class HomeViewController: UIViewController, MyViewDelegate {
    func pushViewController(_ viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewViewController()
            vc.configurePoster()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    let sectionTitles: [String] = ["Top Rated", "Popular", "Upcoming"]
    
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Movies", "TV Shows"])
        
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .red
        sc.layer.cornerRadius = 120
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    
    let posterGenreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-BoldMT", size: 30)
        label.text = "Chainsaw Man"
        return label
    }()

    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)

        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        let posterView = PosterHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        posterView.delegate = self
        homeFeedTable.tableHeaderView = posterView
        
        view.backgroundColor = .systemBackground

             self.navigationItem.titleView = segmentedControl
        applyConstraints()
 
        homeFeedTable.separatorStyle = .none
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
   
    // MARK: - Func
    
    func applyConstraints() {
           segmentedControl.translatesAutoresizingMaskIntoConstraints = false
           segmentedControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
           segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
       }
    
    @objc private func saveButtonTapped(_ sender: Any) {

        DispatchQueue.main.async { [weak self] in
            let vc = PreviewViewController()
            vc.configurePoster()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc fileprivate func handleSegmentChange(segmentedControl: UISegmentedControl) {
      
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            homeFeedTable.reloadData()
        case 1:
            homeFeedTable.reloadData()
        default:
            break
        }
    
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
        
        cell.delegate = self
        
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            cell.movie = true
            switch indexPath.section {
            case Sections.Popular.rawValue:
                NetworkService.shared.fetchPopularMoviesAF { result in

                    cell.configure(with: result)
                }
                
            case Sections.Upcoming.rawValue:
                NetworkService.shared.fetchUpcomingMoviesAF { result in

                    cell.configure(with: result)
                }
                
            case Sections.TopRated.rawValue:
                NetworkService.shared.fetchTopRatedMoviesAF { result in
                    
                    cell.configure(with: result)
                }
            default:
                return UITableViewCell()
            }
        case 1:
            cell.movie = false
            switch indexPath.section {
            case Sections.Popular.rawValue:
                NetworkService.shared.fetchPopularTvAF { result in

                    cell.configure(with: result)
                }
                
            case Sections.Upcoming.rawValue:
                NetworkService.shared.fetchUpcomingTvAF { result in

                    cell.configure(with: result)
                }
                
            case Sections.TopRated.rawValue:
                NetworkService.shared.fetchTopRatedTvAF { result in
                    
                    cell.configure(with: result)
                }
            default:
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
            return cell
            
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: PreviewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

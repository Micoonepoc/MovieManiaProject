import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: PreviewModel)
}

    class SearchResultViewController: UIViewController {
        
        var movie = false
        
        public weak var delegate: SearchResultsViewControllerDelegate?
        
        public var titles: [Movie] = [Movie]()
        public var testTitles: [TestModel] = [TestModel]()

    
        public let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
            
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.layer.cornerRadius = 10
        
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
        searchResultsCollectionView.layer.cornerRadius = 10
        
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return testTitles.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = testTitles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch movie {
            
        case true:
            let title = titles[indexPath.row]
            if let titleName = title.original_title  {
                NetworkService.shared.getYouTubeResponse(with: titleName + " trailer") { [weak self] result in

                    let title = self?.titles[indexPath.row]
                    guard let titleOverview = title?.overview else {
                        return
                    }
                    guard let rating = title?.vote_average else {
                        return
                    }
                    guard let voteCount = title?.vote_count else {
                        return
                    }
                    let viewModel = PreviewModel(title: titleName, youtubeVideo: result, titleOverView: titleOverview, rating: rating, vote_count: voteCount)
                    self?.delegate?.searchResultsViewControllerDidTapItem(viewModel)

                }
            }
        case false:
            let title = testTitles[indexPath.row]
            if let titleName = title.original_name ?? title.original_title {
                NetworkService.shared.getYouTubeResponse(with: titleName + " trailer") { [weak self] result in

                    let title = self?.testTitles[indexPath.row]
                    guard let titleOverview = title?.overview else {
                        return
                    }
                    guard let rating = title?.vote_average else {
                        return
                    }
                    guard let voteCount = title?.vote_count else {
                        return
                    }
                    let viewModel = PreviewModel(title: titleName, youtubeVideo: result, titleOverView: titleOverview, rating: rating, vote_count: voteCount)
                    self?.delegate?.searchResultsViewControllerDidTapItem(viewModel)

                }
            }
        }
    }
}

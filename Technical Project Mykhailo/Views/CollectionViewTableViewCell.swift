import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: PreviewModel)
}

protocol SegmentedIndexChange: AnyObject {
    
    func selectedIndex(index: Int)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    var movie = true

  static let identifier = "CollectionViewTableViewCell"
    
  private var titles: [Movie] = [Movie]()
    private var tvtitles: [TV] = [TV]()
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    func configure(with titles: [Movie]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    func configure(with titles: [TV]) {
        self.tvtitles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func downloadTitleAt(indexPath: IndexPath) {
        
        switch movie {
            
        case true:
            DataPersistenceManager.shared.downloadMovieWith(model: titles[indexPath.row]) { result in
                switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case false:
            DataPersistenceManager.shared.downloadTvWith(model: tvtitles[indexPath.row]) { result in
                switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                    print("got it")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
   
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
            
        }
        
        switch movie {
        case true:
            if let model = titles[indexPath.row].poster_path {
                cell.configure(with: model)
            }
               
        case false:
            
            if let model = tvtitles[indexPath.row].poster_path {
                cell.configure(with: model)
            }
        }
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch movie {
            
        case true:
            return titles.count
        case false:
            return tvtitles.count
        }
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
                    guard let strongSelf = self else {
                        return
                    }
                    let viewModel = PreviewModel(title: titleName, youtubeVideo: result, titleOverView: titleOverview, rating: rating, vote_count: voteCount)
                    self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                    
                }
            }
        case false:
            let title = tvtitles[indexPath.row]
            if let titleName = title.name {
                NetworkService.shared.getYouTubeResponse(with: titleName + " trailer") { [weak self] result in
                    
                    let title = self?.tvtitles[indexPath.row]
                    guard let titleOverview = title?.overview else {
                        return
                    }
                    guard let rating = title?.vote_average else {
                        return
                    }
                    guard let voteCount = title?.vote_count else {
                        return
                    }
                    guard let strongSelf = self else {
                        return
                    }
                    let viewModel = PreviewModel(title: titleName, youtubeVideo: result, titleOverView: titleOverview, rating: rating, vote_count: voteCount)
                    self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                    
                }
            }
        }
 
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
}

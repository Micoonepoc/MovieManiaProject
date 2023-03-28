import UIKit
import WebKit
import CoreData

class PreviewViewController: UIViewController {

    private var titles: [Movie] = [Movie]()
    private var tvtitles: [TV] = [TV]()
    var movie = true
    
    
    var selectedMovie: Movie?
    
    private let webView: WKWebView = {
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let movieNameLabel: UILabel = {
        
        let movieLabel = UILabel()
        movieLabel.translatesAutoresizingMaskIntoConstraints = false
        movieLabel.textColor = .white
        movieLabel.numberOfLines = 0
        movieLabel.text = ""
        movieLabel.font = UIFont.boldSystemFont(ofSize: 25)
        return movieLabel
        
    }()
    
    private let starImageView: UIImageView = {
        
        let starImageView = UIImageView()
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.image = UIImage(named: "star")
        return starImageView
    }()
    
    private let ratingLabel: UILabel = {
        
        let ratingLabel = UILabel()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 18)
        
        ratingLabel.textColor = .white
        ratingLabel.text = ""
        return ratingLabel
    }()
    
    private let overViewLabel: UILabel = {
        
        let overViewLabel = UILabel()
        overViewLabel.translatesAutoresizingMaskIntoConstraints = false
        overViewLabel.font = UIFont.systemFont(ofSize: 16)
        overViewLabel.numberOfLines = 0
        overViewLabel.textColor = .gray
        overViewLabel.text = ""
        return overViewLabel
    }()
    
    private let seeOnWebButton: UIButton = {
        
        let addToWatchListButton = UIButton()
        addToWatchListButton.translatesAutoresizingMaskIntoConstraints = false
        addToWatchListButton.backgroundColor = .red
        addToWatchListButton.setTitle("See on web", for: .normal)
        addToWatchListButton.setTitleColor(.white, for: .normal)
        addToWatchListButton.layer.cornerRadius = 10
        addToWatchListButton.layer.masksToBounds = true
        addToWatchListButton.addTarget(self, action: #selector(seeOnWebButtonTapped), for: .touchUpInside)
        return addToWatchListButton
    }()
    
    private let ratingCountLabel: UILabel = {
        
        let ratingCountLabel = UILabel()
        ratingCountLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingCountLabel.font = UIFont.systemFont(ofSize: 17)
        ratingCountLabel.textColor = .white
        ratingCountLabel.text = ""
        return ratingCountLabel
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        view.addSubview(movieNameLabel)
        view.addSubview(starImageView)
        view.addSubview(ratingLabel)
        view.addSubview(overViewLabel)
        view.addSubview(seeOnWebButton)
        view.addSubview(ratingCountLabel)
        applyConstraints()
    }
    
    @objc private func seeOnWebButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://www.themoviedb.org") {
               UIApplication.shared.open(url)
           }
    }
    
    
    private func applyConstraints() {
        
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 400)
        ]
        
        let movieNameLabelConstraints = [
            movieNameLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
            movieNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            movieNameLabel.widthAnchor.constraint(equalToConstant: 400)

      
        ]
        
        let starImageViewConstraints = [
            starImageView.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 10),
            starImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let ratingLabelConstraints = [
            
            ratingLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 10),
  
        ]
        
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 10),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        
        let seeOnWebButtonConstraints = [
            
            seeOnWebButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            seeOnWebButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            seeOnWebButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            seeOnWebButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let ratingCountLabelConstraints = [
            
            ratingCountLabel.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            ratingCountLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 10),
            
        ]

        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(movieNameLabelConstraints)
        NSLayoutConstraint.activate(starImageViewConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(seeOnWebButtonConstraints)
        NSLayoutConstraint.activate(ratingCountLabelConstraints)
        
    }
    
    func configure(with model: PreviewViewModel) {
        movieNameLabel.text = model.title
        overViewLabel.text = model.titleOverView
        ratingLabel.text = "\(model.rating)"
        ratingCountLabel.text = "(\(model.vote_count))"

        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVideo.id.videoId)") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    func configurePoster() {
        movieNameLabel.text = "Chainsaw Man"
        overViewLabel.text = "Denji has a simple dream—to live a happy and peaceful life, spending time with a girl he likes. This is a far cry from reality, however, as Denji is forced by the yakuza into killing devils in order to pay off his crushing debts. Using his pet devil Pochita as a weapon, he is ready to do anything for a bit of cash."
        ratingLabel.text = "8.7"
        ratingCountLabel.text = "(945)"

        
        guard let url = URL(string: "https://www.youtube.com/embed/j9sSzNmB5po") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}

import UIKit

class SearchTableViewCell: UITableViewCell {


    static let identifier = "SearchTableViewCell"

    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
   let movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.numberOfLines = 4
        return label
    }()
    
    let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(movieOverviewLabel)
        contentView.addSubview(starImageView)
        contentView.addSubview(movieRatingLabel)
        
    }
    
    public func configure(with model: TitleModel) {

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        posterImageView.sd_setImage(with: url, completed: nil)
        movieNameLabel.text = model.titleName
        movieOverviewLabel.text = model.overview
        movieRatingLabel.text = "\(model.rating)"
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 150),
            
            movieNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            movieNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            movieOverviewLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 10),
            movieOverviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            movieOverviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            
            starImageView.topAnchor.constraint(equalTo: movieOverviewLabel.bottomAnchor, constant: 10),
            starImageView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            
            movieRatingLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            movieRatingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 5),
            movieRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}

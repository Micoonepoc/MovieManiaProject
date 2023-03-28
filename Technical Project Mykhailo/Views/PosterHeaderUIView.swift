import UIKit

protocol MyViewDelegate: AnyObject {
  func pushViewController(_ viewController: UIViewController)
}

class PosterHeaderUIView: UIView {
    
    
    weak var delegate: MyViewDelegate?
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "PosterImage")
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "seeMore"), for: .normal)
        button.alpha = 0.7
        return button
    }()
    
    private let seeOnWebButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(seeOnWebButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "SeeOnWeb"), for: .normal)
        button.alpha = 0.7
        return button
    }()
    
    private let posterNameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "chainsawlogo")
        return imageView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterImageView)
        addGradient()
        addSubview(seeOnWebButton)
        addSubview(playButton)
        applyConstraints()
        addSubview(posterNameImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    @objc private func saveButtonTapped(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewViewController()
            vc.configurePoster()
            self?.delegate?.pushViewController(vc)
        }
    }
    
    @objc private func seeOnWebButtonTapped(_ sender: Any) {
        
        if let url = URL(string: "https://www.themoviedb.org/tv/114410") {
               UIApplication.shared.open(url)
           }

    }
    
    private func applyConstraints() {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            playButton.widthAnchor.constraint(equalToConstant: 130),
            playButton.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        let seeOnWebButtonConstraints = [
            seeOnWebButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            seeOnWebButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            seeOnWebButton.widthAnchor.constraint(equalToConstant: 130),
            seeOnWebButton.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        posterNameImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(posterNameImage)
        
        let posterNameImageConstraints = [
            posterNameImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            posterNameImage.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -1),
            posterNameImage.widthAnchor.constraint(equalToConstant: 220),
            posterNameImage.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints + seeOnWebButtonConstraints + posterNameImageConstraints)
    }


}


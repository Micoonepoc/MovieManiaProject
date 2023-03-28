import UIKit

class ProfileViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let minimumDate = dateFormatter.date(from: "1900-01-01")
        datePicker.minimumDate = minimumDate
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray
        imageView.image = UIImage(named: "DefaultUserImage")
        return imageView
    }()
    
    private let editImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(editImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name:"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your name"
        textField.isEnabled = false
        return textField
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email:"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your email"
        textField.isEnabled = false
        return textField
    }()
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Birthday:"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your birthday"
        textField.isEnabled = false
        return textField
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Favorite Genre:"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let genreTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your favorite genre"
        textField.isEnabled = false
        return textField
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "user"), for: .normal)
         button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
         return button
     }()
    
    private var isEditingProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        birthdayTextField.inputView = datePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        saveDataToUserDefaults()
    
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, emailLabel, emailTextField, birthdayLabel, birthdayTextField, genreLabel, genreTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        
        view.addSubview(profileImageView)
        view.addSubview(editImageButton)
        view.addSubview(stackView)
        view.addSubview(editButton)
        view.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            
            editImageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            editImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            editImageButton.widthAnchor.constraint(equalToConstant: 40),
            editImageButton.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            editButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 100),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 300),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            

            clearButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            clearButton.widthAnchor.constraint(equalToConstant: 40),
            clearButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func saveDataToUserDefaults() {
        
        if let savedImage = getImageFromUserDefaults(key: "imageKey") {
            profileImageView.image = savedImage
        }
        if let savedName = defaults.string(forKey: "textNameKey") {
            nameTextField.text = savedName
        }
 
 if let savedEmail = defaults.string(forKey: "textEmailKey") {
     emailTextField.text = savedEmail
 }
 
 if let savedBirthday = defaults.string(forKey: "textBirthdayKey") {
     birthdayTextField.text = savedBirthday
 }
 
 if let savedGenre = defaults.string(forKey: "textGenreKey") {
     genreTextField.text = savedGenre
 }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func saveImageToUserDefaults(image: UIImage, key: String) {
           let imageData = image.pngData()
           defaults.set(imageData, forKey: key)
       }

       func getImageFromUserDefaults(key: String) -> UIImage? {
           if let imageData = defaults.object(forKey: key) as? Data {
               return UIImage(data: imageData)
           }
           return nil
       }
    
    @objc func clearButtonTapped() {
       
          UserDefaults.standard.removeObject(forKey: "textNameKey")
        UserDefaults.standard.removeObject(forKey: "textEmailKey")
        UserDefaults.standard.removeObject(forKey: "textBirthdayKey")
        UserDefaults.standard.removeObject(forKey: "textGenreKey")

 
          UserDefaults.standard.removeObject(forKey: "savedImage")

          UserDefaults.standard.synchronize()
          
          nameTextField.text = ""
        emailTextField.text = ""
        birthdayTextField.text = ""
        genreTextField.text = ""
        
         
          profileImageView.image = UIImage(named: "DefaultUserImage")
        
        let alert = UIAlertController(title: "Clear data", message: "Data was cleared", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alert.addAction(okAction)
          present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    @objc func editButtonTapped() {
        isEditingProfile.toggle()
        
        if isEditingProfile {
            editButton.setTitle("Save", for: .normal)
            nameTextField.isEnabled = true
            emailTextField.isEnabled = true
            birthdayTextField.isEnabled = true
            genreTextField.isEnabled = true
        } else {
            editButton.setTitle("Edit Profile", for: .normal)
            nameTextField.isEnabled = false
            emailTextField.isEnabled = false
            birthdayTextField.isEnabled = false
            genreTextField.isEnabled = false
        }
        
        if let text = nameTextField.text {
                  defaults.set(text, forKey: "textNameKey")
              }
        
        if let text = emailTextField.text {
                  defaults.set(text, forKey: "textEmailKey")
              }
        
        if let text = birthdayTextField.text {
                  defaults.set(text, forKey: "textBirthdayKey")
              }
        
        if let text = genreTextField.text {
                  defaults.set(text, forKey: "textGenreKey")
              }
              if let image = profileImageView.image {
                  saveImageToUserDefaults(image: image, key: "imageKey")
              }
    }
    
    @objc func editImageButtonTapped() {
        guard isEditingProfile else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        dismiss(animated: true)
    }
}


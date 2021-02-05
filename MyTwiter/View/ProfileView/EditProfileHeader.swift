import UIKit


protocol EditProfileHeaderDelegate: class{
    func handleChangeImage(imageViewProfile: UIImageView)
}

class EditProfileHeader: UIView {
    //MARK: Properties
    
    private var user: User {
        didSet{
            configure()
        }
    }
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        label.text = " Change photo Profile"
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var imageProfile: UIImageView = {
       let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 100 / 2
        iv.setDimensions(width: 100, height: 100)
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 4
        iv.backgroundColor = .twitterBlue
        iv.layer.borderColor = UIColor.white.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        iv.isUserInteractionEnabled  = true
        iv.addGestureRecognizer(tap)
        iv.sd_setImage(with: user.profileImageUrl, completed: nil)
        return iv
    }()
    
    weak var delegate: EditProfileHeaderDelegate?
    
    
    
    
    //MARK: Lifecycle
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    //MARK: Helpers
    
    func configureUI(){
        backgroundColor = .twitterBlue
        
        addSubview(imageProfile)
        imageProfile.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20).isActive = true
        imageProfile.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        imageProfile.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(changeLabel)
        changeLabel.anchor(top: imageProfile.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        
        
        
    }
    
    func configure(){
      
        
    }
    
    
    //MARK: Selectors
    
    @objc func handleChangePhoto(){
        delegate?.handleChangeImage(imageViewProfile: imageProfile)
    }
    
}



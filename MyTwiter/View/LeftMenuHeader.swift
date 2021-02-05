import UIKit



class LeftMenuHeader: UIView {
    
    //MARK: Properties
    var user: User
    
    private let imageProfile: UIImageView = {
       let iv = UIImageView()
        iv.layer.cornerRadius = 100 / 2
        iv.setDimensions(width: 100, height: 100)
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    
    private let followers: UILabel  = {
        let label = UILabel()
        label.text = "follows: 4"
        label.textColor = .white
        label.textAlignment = .left

        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let following: UILabel  = {
        let label = UILabel()
        label.text = "follows: 4"
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    
    //MARK: Lifecycle
    init(user: User, frame: CGRect) {
        self.user = user
        super.init(frame: frame)
        
        configureUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: Helpers
    func configureUI(){
       addSubview(imageProfile)
        imageProfile.anchor(top: topAnchor, paddingTop: 15)
        imageProfile.centerX(inView: self)
        
        let stackFollow = UIStackView(arrangedSubviews: [followers, following])
        stackFollow.axis = .horizontal
      
        stackFollow.distribution = .fill
        stackFollow.spacing = -1
      
        
        addSubview(stackFollow)
        stackFollow.anchor(top: imageProfile.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 12, paddingRight: 5)
    }
    
    
    func  configure(){
        let viewModel = ProfileHeaderViewModel(user: user)
        imageProfile.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        
        viewModel.followCountSet(following: following, followers: followers, color: .white)
       
        
    }
    
    
    //MARK: Selectors
   
    
    
}

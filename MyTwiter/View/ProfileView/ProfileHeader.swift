import UIKit

protocol  ProfileHeaderDelegate: class {
    func handleDismissal()
    
    func handleEditProfileFollow(_ header: ProfileHeader)
    func handlerOptionFilter(_ option: ProfileFilterOption)
}


class ProfileHeader: UICollectionReusableView{
    
    
    
    //MARK: - Properties
    
    
    weak var delegate: ProfileHeaderDelegate?

    var user: User? {
        didSet{
            
           configure()
        }
    }
    
    private lazy var containetView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
        
    }()
    
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        
        
        return iv
    }()
    
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        
        
        return button
    }()

    
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 1
        label.textColor = .black
        label.text = "Loadung fullname"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "@username"
        label.numberOfLines = 1
        return label
    }()
    
    private let bioLable: UILabel = {
       let label = UILabel()
        label.text = "this is test"
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let underlineView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 330, width: 100, height: 2))
        view.backgroundColor = .twitterBlue
        
        return view
    }()
    
    private var leftUnderlineConstraint: NSLayoutConstraint?
    
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        
 
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        label.text = "Loading..."
        label.textColor = .black
        
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        
        
        
        
        label.text = "Loading..."
        label.textColor = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        
        return label
    }()
    
    
    
    
    //MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        
        
        backgroundColor = .white
        
        
        addSubview(containetView)
        containetView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: containetView.bottomAnchor, constant: 17).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containetView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12, width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLable])
        userDetailStack.axis = .vertical
        userDetailStack.spacing = 1
        userDetailStack.alignment = .leading
        userDetailStack.distribution = .fillProportionally
        
        addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 12)
        
        

        let stackFollow = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        stackFollow.axis = .horizontal
        stackFollow.spacing = 8
        stackFollow.distribution = .fill
        
        addSubview(stackFollow)
        stackFollow.anchor(top: userDetailStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, height: 20)
        
        
        let filterView = ProfileFilterView()
        filterView.delegate = self
        addSubview(filterView)
        filterView.anchor(top: stackFollow.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5)
        filterView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        addSubview(underlineView)
        underlineView.anchor( bottom: bottomAnchor, paddingTop: 10, width: frame.width  / 3, height: 2)
        
        leftUnderlineConstraint =  underlineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        leftUnderlineConstraint?.isActive = true
        
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Selectors
    
    
    @objc func handleDismissal(){
        delegate?.handleDismissal()
    }
    
    
    
    @objc func handleEditProfileFollow(){
        delegate?.handleEditProfileFollow(self)
        
    }
    
    @objc func handleFollowingTapped(){
      
    }
    
    @objc func handleFollowersTapped(){
        
    }
    
    
    //MARK: Helpers
    
    func configure(){
        
        guard let user = user else { return }
        let viewModal = ProfileHeaderViewModel(user: user)
        
        
        
        fullnameLabel.text = viewModal.fullname
        usernameLabel.text = viewModal.username
        bioLable.text = viewModal.bio
        
        profileImageView.sd_setImage(with: viewModal.profileImageUrl, completed: nil)
        
        
        viewModal.followCountSet(following: followingLabel, followers: followersLabel)
        viewModal.actionButtonTitle(button: editProfileFollowButton)
        
    }
    
}


extension ProfileHeader: ProfileFilterViewDelgate {
    
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {

        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }
        let xPosition = cell.frame.origin.x
        self.layoutIfNeeded()
        
        Utilites.shared.generator(generateType: .light)
        
        UIView.animate(withDuration: 0.6) {
            self.leftUnderlineConstraint?.constant = xPosition
            self.layoutIfNeeded()

        }
        
        let option = ProfileFilterOption(rawValue: indexPath.row)
        delegate?.handlerOptionFilter(option!)
    }
    
}

import UIKit



class UserCell: UITableViewCell {
    
    
    
    //MARK: Properties
    var user: User?{
        didSet{
            configure()
        }
    }
    
    
    private  var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 36, height: 36)
        iv.layer.cornerRadius = 36 / 2
        iv.backgroundColor = .twitterBlue
        
        
        return iv
    }()
    
    
    
    private let labelUsername: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "zaremban"
        label.textColor = .black
        return label
    }()
    
    private let labelFullname: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.text = "Zaremba Nikita"
        return label
    }()
    
    
    private let viewSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.4
        
        return view
    }()
    
    
    //MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        configureUI()
    }
    
    
    
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: Helpers
    func configure(){
        
        guard let user = user else { return }
        labelFullname.text = user.fullname
        labelUsername.text = user.username
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
    }
    
    func configureUI(){
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackUserData = UIStackView(arrangedSubviews: [labelUsername, labelFullname])
        stackUserData.axis = .vertical
        stackUserData.distribution = .fillProportionally
        stackUserData.spacing = 2
        stackUserData.contentMode = .left
        
        
        addSubview(stackUserData)
        stackUserData.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackUserData.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 20).isActive = true
        stackUserData.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(viewSeparator)
        viewSeparator.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }
    
}

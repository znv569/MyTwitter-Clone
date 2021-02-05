import UIKit

protocol NotificationCellDelegate {
    func tappedProfileImage(user: User)
    func tappedFollowButton(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    
    //MARK: Properties
    var delegate: NotificationCellDelegate?
    var notification: NotificationTweet?{
        didSet{
            configure()
        }
    }
    
    private lazy var imageProfileView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 48, height: 48)
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
        iv.layer.cornerRadius = 48 / 2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapProfileSelector))
        iv.addGestureRecognizer(tap)
        
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    
    private lazy var buttonFollow: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 30 / 2
        button.setDimensions(width: 80, height: 30)
        button.layer.borderWidth = 1.4
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.setTitle("Loading...", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(handleTapFollow), for: .touchUpInside)
        return button
    }()
    
    private lazy var textLabelNotification: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    
    private let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.alpha = 0.2
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: Helpers
    
    
    func configureUI(){
        
        imageView?.removeFromSuperview()
        textLabel?.removeFromSuperview()
        
       
        backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [imageProfileView, textLabelNotification])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 8
        stack.alignment = .center
        
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 2, paddingLeft: 12, paddingBottom: 2, paddingRight: 12)
        
        addSubview(buttonFollow)
        buttonFollow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonFollow.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        buttonFollow.translatesAutoresizingMaskIntoConstraints = false
        
        stack.trailingAnchor.constraint(equalTo: buttonFollow.leadingAnchor, constant: 20).isActive = true
        
        addSubview(separatorView)
        separatorView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
      
        
        
    }
    
    func configure(){
        
        guard let notification = notification else {return}
        
        let viewModel = NotificationViewModel(notification: notification)
        viewModel.setImageProfile(forImageView: imageProfileView)
        textLabelNotification.attributedText = viewModel.labelNotification
        viewModel.actionButtonTitle(button: buttonFollow)
        
    }
    
    //MARK: Selectors
    
    @objc func tapProfileSelector(){
        
        delegate?.tappedProfileImage(user: notification!.user)
        
    }
    
    @objc func handleTapFollow(){
        delegate?.tappedFollowButton(self)
    }
    
    
}

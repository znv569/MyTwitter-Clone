import UIKit
import Firebase
import ActiveLabel

protocol TweetCellDelegate: class {
    func handleProfileImageTapped(user: User)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
    func handleReplyFromLabel(_ user: User)
}


class TweetCell: UICollectionViewCell{

   
    
    //MARK: - Properties
    
    
    var tweet: Tweet? {
        didSet{
            configure()
        }
    }
    

    private var configureUIisset = false
    var numberRow: Double = 0
    
    weak var delegate: TweetCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Some test caption"
        label.textColor = .black
        return label
    }()
    
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        
        
        
        button.setTitleColor(.black, for: .normal)
        button.setDimensions(width: 40, height: 20)
        button.titleEdgeInsets.left = -40
        button.imageEdgeInsets.left = 20
        button.titleEdgeInsets.top = -3
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        
        
        
        return button
    }()
    

    
    
    private lazy var retweetButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var likeButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    
    private let replyFromLabel: ActiveLabel = {
       let label = ActiveLabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.mentionColor = .twitterBlue
        label.textColor = .lightGray
        label.hashtagColor = .lightGray
        label.isHidden = true
        return label
    }()
    
    private var heightReplyFromLabel: NSLayoutConstraint!
    
    
    
    //MARK: - Lifecycle
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureActiveLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: - Selectors
    
    
    @objc func handleProfileImageTapped(){
        guard let tweet = tweet else { return }
        delegate?.handleProfileImageTapped(user: tweet.user)
    }
    
    @objc func handleCommentTapped(){
        delegate?.handleReplyTapped(self)
    }
    
    
    @objc func handleRetweetTapped(){
        
    }
    
    
    @objc func handleLikeTapped(){
        delegate?.handleLikeTapped(self)
    }
    
    @objc func handleShareTapped(){
        
    }
    
    
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
        guard configureUIisset == false else{
            configureUIisset = true
            return
        }
        
        backgroundColor = .white
        
        
        
        addSubview(replyFromLabel)
        replyFromLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 3, paddingLeft: 5, paddingRight: 5)
        heightReplyFromLabel = replyFromLabel.heightAnchor.constraint(equalToConstant: 0)
        heightReplyFromLabel.isActive = true
        
        addSubview(profileImageView)
        profileImageView.anchor(top: replyFromLabel.bottomAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 8)
        
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        
        
        addSubview(stack)
        stack.anchor(top: replyFromLabel.bottomAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 12, paddingRight: 12)
        
        
        
        
        
        
        infoLabel.text = "Eddie Brock @venom"
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        
        
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        
        
        addSubview(actionStack)
        actionStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
        
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray
        underlineView.alpha = 0.4
        addSubview(underlineView)
        
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        
    }
    
    
    
    func configure(){
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        
        captionLabel.text = tweet.caption
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        infoLabel.attributedText = viewModel.userInfoText
        commentButton.setTitle(String(tweet.countReply), for: .normal)
        
        viewModel.setLikesButton(buttton: likeButton)
        viewModel.setReplys(buttonForTextCount: commentButton, time: numberRow)
        
        viewModel.setFromReplyUsername(label: replyFromLabel, heightConstarint: heightReplyFromLabel)
        
        
    }
    
    
    func configureActiveLabel(){
        replyFromLabel.handleMentionTap { mention in
            UserService.shared.fetchUser(username: mention) { user in
       
                self.delegate?.handleReplyFromLabel(user)
            }
    
        }
        
    }
    
    
    
    

    
    
    
    
}






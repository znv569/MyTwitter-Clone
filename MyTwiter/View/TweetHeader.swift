import UIKit

protocol TweetHeaderDelegate: class {
    func showActionSheet()
    func commentMainTweet()
    func likeTweet(likeButton button: UIButton)
}

class TweetHeader: UICollectionReusableView {

    //MARK: Properies
    
    weak var delegate: TweetHeaderDelegate?
    var tweet: Tweet?{
        didSet{
            configure()
        }
    }
    
    
    private let replyFromLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private var heightConstraintReplyLabel : NSLayoutConstraint?
    
    private lazy var imageProfile: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 44, height: 44)
        iv.backgroundColor = .twitterBlue
        iv.layer.cornerRadius = 44 / 2
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlerProfile))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    private let labelFullname: UILabel = {
        let label = UILabel()
        label.text = "Loading Loading"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    
    private let labelUsername: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "@loading..."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
        
    }()
    
    
    private let labelCaption: UILabel = {
       let label = UILabel()
        label.text = "Loading text caption"
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    
    private lazy var detailButton: UIButton = {
        
        let button = UIButton(type: .system)
        let img = #imageLiteral(resourceName: "down_arrow_24pt").withRenderingMode(.alwaysTemplate)
        button.setImage(img, for: .normal)
        button.tintColor = .lightGray
        button.tintAdjustmentMode = .dimmed
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
        
    }()
    
    
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.text = "0:00 PM 00/00/0000"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    private let labelLikes: UILabel = {
        let label = UILabel()
        label.text = "0 likes"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.contentMode = .left
    
        return label
    }()
    
    private let labelReplys: UILabel = {
        let label = UILabel()
        label.text = "0 replys"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.contentMode = .left
    
        return label
    }()
    
    
    private let labelRetweet: UILabel = {
        let label = UILabel()
        label.text = "0 rewtweets"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.contentMode = .left
        return label
    }()
    
    
    
    private let underLine: UIView = {
        
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.1
        return view
        
    }()
    
    
    private let topLine: UIView = {
        
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.1
        
        return view
        
    }()
    
    
    
    private lazy var commentButton: UIButton = {
        
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var retweetButton: UIButton = {
        
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var likeButton: UIButton = {
        
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    //MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func configureUI(){
        
        
        
        addSubview(replyFromLabel)
        replyFromLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 5, paddingRight: 5)
        heightConstraintReplyLabel = replyFromLabel.heightAnchor.constraint(equalToConstant: 0)
        heightConstraintReplyLabel?.isActive = true
        
        
        addSubview(imageProfile)
        imageProfile.anchor(top: replyFromLabel.bottomAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 15, width: 44, height: 44)
        
        
        let stackNames = UIStackView(arrangedSubviews: [labelFullname, labelUsername])
        stackNames.axis = .vertical
        stackNames.spacing = 4
        stackNames.distribution = .fillProportionally
        
        addSubview(stackNames)
        stackNames.anchor(top: replyFromLabel.bottomAnchor, left: imageProfile.rightAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12,  height: 40)
        
        
        
        addSubview(detailButton)
        detailButton.anchor(top: replyFromLabel.bottomAnchor, right: rightAnchor, paddingTop: 25, paddingRight: 15, width: 30, height: 18)
        
        
        
        
        
        let stackCaptionDateLike = UIStackView(arrangedSubviews: [labelCaption, dateLabel])
        
        stackCaptionDateLike.axis = .vertical
        stackCaptionDateLike.distribution = .fillProportionally
        stackCaptionDateLike.spacing = 10
        
        addSubview(stackCaptionDateLike)
        stackCaptionDateLike.anchor(top: imageProfile.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 12, paddingRight: 12, height: nil)
        
        
        
        
        let stackCount = UIStackView(arrangedSubviews: [labelLikes, labelRetweet, labelReplys])
        stackCount.axis = .horizontal
        stackCount.distribution = .fillProportionally
        stackCount.contentMode = .left
        stackCount.spacing = 10
        
        addSubview(stackCount)
        stackCount.anchor(top: stackCaptionDateLike.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12, height: 40)
        
        addSubview(topLine)
        topLine.anchor(top: stackCount.topAnchor, left: leftAnchor, right: rightAnchor)
        
        addSubview(underLine)
        underLine.anchor(top: stackCount.bottomAnchor, left: leftAnchor, right: rightAnchor)
        
        
        
        let stackButton = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        stackButton.axis = .horizontal
        
        stackButton.distribution = .equalCentering
        stackButton.spacing = 72
        
        addSubview(stackButton)
        stackButton.anchor(top: underLine.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 50, paddingRight: 50, height: nil)
        
    }
    
    
    
    //MARK: Helpers
    
    
    func createButton(withImageName name: String) -> UIButton{
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: name), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    
    func configure(){
        guard let tweet = tweet else { return }
        
        let viewModel  = TweetViewModel(tweet: tweet)
        
     
        viewModel.setProfileImage(imageView: imageProfile)
        viewModel.setReplys(label: labelReplys)
        viewModel.setLikesButton(buttton: likeButton)
        
        labelUsername.text = viewModel.username
        labelFullname.text = viewModel.fullname
        labelCaption.text = viewModel.caption
        labelLikes.attributedText = viewModel.likes
        labelRetweet.attributedText = viewModel.retweets
        
        dateLabel.text = viewModel.fullTimestamp
        
        viewModel.setFromReplyUsername(label: replyFromLabel, heightConstarint: heightConstraintReplyLabel!)
        
    }
    
    
    //MARK: Selectors
    @objc func handlerProfile(){
        
    }
    
    
    @objc func showActionSheet(){
        delegate?.showActionSheet()
    }
    
    
    
    @objc func handleCommentTapped(){
        
        delegate?.commentMainTweet()
        
    }
    
    
    @objc func handleRetweetTapped(){
    
    }
    
    
    
    @objc func handleLikeTapped(){
        delegate?.likeTweet(likeButton: likeButton)
    }
    
    
    
    @objc func handleShareTapped(){
    
    }
    
    
}

import UIKit
import ActiveLabel

enum UploadTweetConfiguration{
    case tweet
    case retweet(Tweet)
}


class UploadTweetsController: UIViewController {
    
    
    //MARK: - Properies
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    
    
    
    
    private let captionTextView = CaptionTextView(frame: CGRect(x: 0, y: 0, width: 300, height: 100), textContainer: nil)
    
    
    
    private lazy var actionButton: UIButton = {
        
        
        let button = UIButton(type: .system)
        button.setTitle("Tweet", for: .normal)
        button.backgroundColor = .twitterBlue
        button.layer.cornerRadius = 32 / 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button .addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        return button
    }()
    
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.isHidden = true
        label.mentionColor = .twitterBlue
        //label.heightAnchor.constraint(equalToConstant: 0).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    
    //MARK: - Lifecycle
    
    init(user: User, configure: UploadTweetConfiguration){
        self.user = user
        self.config = configure
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
        configMode()
        configureMentionHandle()
    }
    
    
    //MARK: - Selectors
    @objc func handleCancel(button: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadTweet(button: UIButton){
        
        guard let caption = captionTextView.text else { return }
 
        TweetService.shared.uploadTweet(caption: caption, config: config) { (error) in
                if let error = error {
                    print("DEBUG: Error database tweet with error: \(error.localizedDescription)")
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
     
        
        
        
    }
    
    //MARK: - API
    
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()

        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        
        let containerViewForImage = UIView()
        containerViewForImage.addSubview(profileImageView)
        
        
        
        let dispQueue = DispatchQueue(label: "myQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        dispQueue.async {
            
        }
        
        profileImageView.anchor(top: containerViewForImage.topAnchor, left: containerViewForImage.leftAnchor)
        containerViewForImage.setDimensions(width: 50, height: 50)
        
        
        view.addSubview(replyLabel)
    
        replyLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 12, paddingRight: 12)
        
        
        
        
        let stack = UIStackView(arrangedSubviews: [profileImageView , captionTextView])
       
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillProportionally
        stack.alignment = .top
        
        view.addSubview(stack)
        stack.anchor(top: replyLabel.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        
       
    }
    
    func configMode(){
        
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        
        if viewModel.shouldShowReplayLabel {
            replyLabel.attributedText = viewModel.replyText
            //replyLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            replyLabel.isHidden = false
        }
        
    }
    
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    
    func configureMentionHandle(){
        replyLabel.handleMentionTap { mention in
            let controller = ProfileController(user: self.user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}






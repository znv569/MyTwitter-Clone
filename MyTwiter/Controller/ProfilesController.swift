import UIKit
import Firebase

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"




class ProfileController: UICollectionViewController {
    
    
    //MARK: - Properties
    private let user: User
    
    
    
    private var tweets = [Tweet]()
    
    private var likeTweets = [Tweet]()
    
    
    private var replicesTweets = [Tweet]()
    private weak var header: ProfileHeader?
    
    private var currentTab: ProfileFilterOption = .tweets
    
    private var listenerLike: ListenerRegistration?
    private var listerReplys: ListenerRegistration?
    private var listerTweets: ListenerRegistration?
    
    
    var mainTweets = [Tweet](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    
    
    //MARK: Lifecycle

    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        
        
        
        guard let indexPath = collectionView.indexPathsForSelectedItems else {return}
        
        indexPath.forEach { index in
            collectionView.deselectItem(at: index, animated: true)
        }
        
        collectionView.reloadItems(at: indexPath)
        header?.configure()
        
        
    }

        
        
        
    
    
    
    
    //MARK: - Helpers
    
    func configureCollectionView() {
        
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
       
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        view.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handlerRefresh), for: .valueChanged)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        
    }
    
    
    
    
    
    
    func configure(){
        collectionView.refreshControl?.beginRefreshing()
        configureTweets()
        configureReplys()
        configureLikes()
    }
    
    
    
    func configureLikes(){
       listenerLike?.remove()
        
       listenerLike = TweetService.shared.fetchLikeTweets(user: user) { (tweets) in
            self.likeTweets = tweets
            
            if self.currentTab == .likes {
                self.mainTweets = self.likeTweets
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
            }
            
        }
    }
    
    func configureReplys(){
        listerReplys?.remove()
        listerReplys = TweetService.shared.fetchUserReplys(user: user) { (tweets) in
            self.replicesTweets = tweets
            
            
            if self.currentTab == .replies {
                self.mainTweets = self.replicesTweets
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
            }
            
        }
    }
    
    
    
    
    func configureTweets(){
        listerTweets?.remove()
        listerTweets = TweetService.shared.fetchUserTweets(user: user) { (tweets) in
            self.tweets = tweets
            
            if self.currentTab == .tweets {
              self.mainTweets = self.tweets
              self.collectionView.refreshControl?.endRefreshing()
               self.collectionView.reloadData()
            }
            
        }
    }
    
    
    
    //MARK: SELECTORS
    
    @objc func handlerRefresh(){
        collectionView.refreshControl?.beginRefreshing()
        
        switch currentTab {
            case .tweets:
                configureTweets()
            case .replies:
                configureReplys()
            case .likes:
                configureLikes()
        }
    }
    
    
    
}


//MARK: - UICollectionDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainTweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.numberRow = Double(indexPath.row + 1) / 10
        cell.tweet = mainTweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controllerTweet = TweetController(tweet: mainTweets[indexPath.row])
        navigationController?.pushViewController(controllerTweet, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    
    
    
}






//MARK: REUSEBLE view header
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        self.header = header
        return header
    }
}





//MARK: DELEGATE back in navigation controller
extension ProfileController: ProfileHeaderDelegate{
    
    
    func handlerOptionFilter(_ option: ProfileFilterOption) {
        
        currentTab = option
        
        switch option {
            case .tweets:
                mainTweets = tweets
            case .replies:
                mainTweets = replicesTweets
            case .likes:
                mainTweets = likeTweets
            
        }
       
        
    }
    
    
    
    
    
    
    
   
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
            let uid = header.user!.uid
        
                 UserService.shared.checkFollow(uid: uid){[weak header] checks in
                                    guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
                                    if currentUserUid == uid{
                                        
                                        let controller = EditProfileController(user: self.user)
                                        let nav = UINavigationController(rootViewController: controller)
                                        nav.modalPresentationStyle = .fullScreen
                                        self.present(nav, animated: true, completion: nil)
                                        
                                    }else{
                                        if !checks {
                                            UserService.shared.followUser(uid: uid){ _ in
                                                self.user.isFollowed = true
                                                header?.configure()
                                                Utilites.shared.generator(generateType: .success)
                                            }
                                            
                                        }else{
                                            
                                            UserService.shared.unfolllowUser(uid: uid) { _ in
                                                self.user.isFollowed = false
                                                header?.configure()
                                                Utilites.shared.generator(generateType: .success)
                                            }
                                        }
                                }
                 }
        
                
                
    }

    
   
    func handleDismissal() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        
        listenerLike?.remove()
        listerTweets?.remove()
        listerReplys?.remove()
        navigationController?.popViewController(animated: true)
       
    }
    
    
}
//MARK: TweetCellDelegate
extension ProfileController: TweetCellDelegate{
    
    func handleReplyFromLabel(_ user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return}
        TweetService.shared.tapLike(tweet: tweet) {
            cell.configure()
        }
    }
    
    func handleProfileImageTapped(user: User) {
        return
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        Utilites.shared.presentUpload(config: .retweet(cell.tweet!), target: self)
    }
 
}




extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 320)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = mainTweets[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        let heigth = viewModel.size(forWidth: view.frame.width, forSizeFont: .systemFont(ofSize: 14)).height
        return CGSize(width: view.frame.width, height: heigth + 80)
    }
    
    
}

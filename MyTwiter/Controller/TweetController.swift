import UIKit
import Firebase

private let reusebleTweetCell = "TweeCell"
private let reusebleHeader = "HeaderTweet"


class TweetController: UICollectionViewController {
    
    
    //MARK: Properties
    private var actionSheetLauncher: ActionSheetLauncher
    private var tweet: Tweet
    
    
    private var retweets = [Tweet](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var listenerReplys: ListenerRegistration?
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureCollectionView()
        
    }
    
    deinit {
        listenerReplys?.remove()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        guard let indexPath = collectionView.indexPathsForSelectedItems else {return}
        
        indexPath.forEach { index in
            collectionView.deselectItem(at: index, animated: true)
        }
        collectionView.reloadItems(at: indexPath)
        
        
        
    }
    
    
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        configureCollectionView()
        configureRetweets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    //MARK: Helpers
    
    func configureCollectionView(){
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCloseController))
       
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reusebleTweetCell)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusebleHeader)
        
    }
    
    
    func configureRetweets(){
        
    listenerReplys?.remove()
        
     listenerReplys = TweetService.shared.fetchReplys(tweet: tweet) { [weak self] (retweets) in
            self?.retweets = retweets
            
        }
        
    }
    
    //MARK: Selectors
    
    @objc func handleCloseController(){
        navigationController?.popViewController(animated: true)
    }
    
}



//MARK: UICollectionViewDELEGATE and DATA
extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let retweet = retweets[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusebleTweetCell, for: indexPath) as! TweetCell
        cell.numberRow = Double(indexPath.row + 1) / 10
        cell.tweet = retweet
        cell.delegate = self
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newTweetOpen = TweetController(tweet: retweets[indexPath.row])
        navigationController?.pushViewController(newTweetOpen, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return retweets.count
    }
    
}


//MARK: REUSEBLE view header
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusebleHeader, for: indexPath) as! TweetHeader
        
        header.tweet = tweet
        header.delegate = self
        return header
    }
}



//MARK: UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: tweet)
        let heigth = viewModel.size(forWidth: view.frame.width, forSizeFont: .boldSystemFont(ofSize: 19)).height
        return CGSize(width: view.frame.width, height: heigth + 220)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let retweet = retweets[indexPath.row]
            let viewModel = TweetViewModel(tweet: retweet)
            let height = viewModel.size(forWidth: view.frame.width, forSizeFont: .systemFont(ofSize: 14)).height
            return CGSize(width: view.frame.width, height: height + 80)
       
    }
    
}



//MARK: Tweet controller delegate


extension TweetController: TweetCellDelegate{
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
        let controllerProfile = ProfileController(user: user)
        navigationController?.pushViewController(controllerProfile, animated: true)
    }
    
    
    func handleReplyTapped(_ cell: TweetCell) {
        Utilites.shared.presentUpload(config: .retweet(cell.tweet!), target: self)
    }
    
    
}



//MARK: TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate{
    func likeTweet(likeButton button: UIButton) {
        
        TweetService.shared.tapLike(tweet: tweet) {
            
            let viewModel = TweetViewModel(tweet: self.tweet)
            viewModel.setLikesButton(buttton: button)
            
        }
    }

    
    func commentMainTweet() {
        Utilites.shared.presentUpload(config: .retweet(tweet), target: self)
    }
    
    
    fileprivate func showActionSheet(forUser user: User) {
        UserService.shared.checkFollow(uid: user.uid) { (isFollow) in
            self.tweet.user.isFollowed = isFollow
            self.actionSheetLauncher = ActionSheetLauncher(user: user)
            self.actionSheetLauncher.show()
            self.actionSheetLauncher.delegate  = self
        }
    }
    
    func showActionSheet() {
        if !tweet.user.isCsurrentUser {
            showActionSheet(forUser: tweet.user)

        }else{
            actionSheetLauncher.show()
            actionSheetLauncher.delegate = self
        }
        
    }
}



//MARK:

extension TweetController: ActionSheetLauncherDelegate{
    
    
    func didSelect(option: ActionSheetOption) {
        switch option {
        
            case .follow(let user):
                UserService.shared.followUser(uid: user.uid) { (error) in
                    self.tweet.user.isFollowed = false
                }
            case .unfollow(let user):
                UserService.shared.unfolllowUser(uid: user.uid) { (error) in
                    self.tweet.user.isFollowed = true
                    print("Отписан")
                }
            case .report:
                print("report")
                
                
            case .delete:
               
                TweetService.shared.getAllReplys(id: tweet.tweetID) { (tweets) in
                    
                    tweets.forEach { tweetId in
                        TweetService.shared.deleteTweet(tweet: tweetId) { compleat in
                            print("DEBUG: \(tweetId) удален \(compleat)")
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
                    
                }
                
    
        }
    }
    
    
    
    
}



extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

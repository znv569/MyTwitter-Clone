import UIKit
import SDWebImage
import Firebase
import SideMenu

private let reuseIdentifier = "TweetCell"




class FeedController: UICollectionViewController {
    
    
    
    // MARK: - Properies
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var user: User? {
        didSet{
            configureLeftBarItem()
            fetchTweets()
        }
    }
    
    var tweets = [Tweet](){
        
        didSet(oldValue){
                collectionView.reloadDataWithoutScroll()
        }
        
    }
    
    var listener: ListenerRegistration?

        
    
    

    // MARK: - Lifecycle


    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        guard let indexPath = collectionView.indexPathsForSelectedItems else {return}
        
        indexPath.forEach { index in
            collectionView.deselectItem(at: index, animated: true)
        }
        collectionView.reloadItems(at: indexPath)
        
        
    }
    
    
    //MARK: - API
    
    func fetchTweets(){

        
        if listener != nil{
            Utilites.shared.generator(generateType: .success)
        }
        
        
        listener?.remove()
        collectionView.refreshControl?.beginRefreshing()
         
        
         listener = TweetService.shared.fetchTweets(user: user!) { tweets in

            self.tweets = tweets
            self.collectionView.refreshControl?.endRefreshing()


        }
    }


    //MARK: - Helpers
    
    
    func configureUI(){
        
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        let refresh = UIRefreshControl()
        refresh.sizeThatFits(CGSize(width: 2, height: 2))
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: --\(token)--")
            
          }
        }
        
        

    }
    
    func configureLeftBarItem(){
        
        guard let user = user else { return }
        
        //установка фото профиля в navigationItem
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLeftMenu))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
        
        
       
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
    }
    
    
    @objc func handleRefresh(){
       fetchTweets()
    }
    
    @objc func handleLeftMenu(){
        let controller = LeftMenuController(user: user!)
        let menu = SideMenuNavigationController(rootViewController: controller)
        menu.leftSide = true
      
        
        present(menu, animated: true, completion: nil)
    }
    
    
}




extension FeedController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        
        cell.numberRow = Double(indexPath.row + 2) / 5
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweetController = TweetController(tweet: tweets[indexPath.row])
        tweetController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(tweetController, animated: true)
        
        
    }
}


extension FeedController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width - 30, forSizeFont: .systemFont(ofSize: 14)).height
        
        return CGSize(width: view.frame.width, height: height + 80)
    }
}


extension FeedController: TweetCellDelegate{
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
    
    
    
    func handleReplyTapped(_ cell: TweetCell) {
        
        Utilites.shared.presentUpload(config: .retweet(cell.tweet!), target: self)
       
        
    }
    

    
    
    func handleProfileImageTapped(user: User) {
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
}





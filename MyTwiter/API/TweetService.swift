import Firebase



struct TweetService{
    static let shared = TweetService()
    
    
    func uploadTweet(caption: String, config: UploadTweetConfiguration, completion: @escaping(Error?) -> Void){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
          
        
        
        var values = ["uid": uid,
                      "timestamp": Int(Date().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
        "caption": caption] as [String: AnyObject]

        switch config {
        
        case .tweet:
            CLOUD_TWEETS.addDocument(data: values,completion: completion)
            
        case . retweet(let fromTweet):
            values["fromtweet"] = fromTweet.tweetID as AnyObject
            values["replyToUsername"] = fromTweet.user.username as AnyObject
            CLOUD_REPLYS.addDocument(data: values,completion: completion)
            NotificationService.shared.uploadNotification(type: .reply, tweet: fromTweet)
        }
        

      
    }
    
    
    
    func deleteTweet(tweet: String, compleation: @escaping(Bool) -> Void){
        CLOUD_TWEETS.document(tweet).delete { error in
            compleation(true)
        }
        
        CLOUD_REPLYS.document(tweet).delete { error in
            compleation(true)
        }
    }
    
    
    func getTweet(tweetID: String, completion: @escaping(Tweet?)->Void){
        
        CLOUD_TWEETS.document(tweetID).getDocument { (snapshot, error) in
            
            if !snapshot!.exists {
                CLOUD_REPLYS.document(tweetID).getDocument { (snapshot2, error2) in
                    fetchOneTweetResult(snapshot: snapshot2, tweetType: .retweet, compleation: completion)
                }
            }else{
                fetchOneTweetResult(snapshot: snapshot, tweetType: .tweet, compleation: completion)
            }
            
        }
        
    }
    
    
    func getAllReplys(id: String, compleation: @escaping([String]) -> Void){
        
       CLOUD_REPLYS.whereField("fromtweet", isEqualTo: id).order(by: "timestamp", descending: true).limit(to: 20).getDocuments { (querySnapshot, error) in
            var tweetsID: [String] = [id]
            if !querySnapshot!.documents.isEmpty {
                
                    for document in querySnapshot!.documents {
                        
                        tweetsID.append( document.documentID )
                        
                        getAllReplys(id: String(document.documentID) ){ ids in
                            tweetsID.append(contentsOf: ids)
                            tweetsID = tweetsID.removeDuplicates()
                            compleation(tweetsID)
                        }
                    }
                
            }else{
                compleation(tweetsID)
            }
        }
        
    }
    
    
    
    
    
    func fetchTweets(user: User, completion: @escaping([Tweet]) -> Void) -> ListenerRegistration{
        
        
        var userFollow: [String] = [user.uid]
        
        if let follow = user.follow {
            userFollow.append(contentsOf: follow)
        }
        
        
        
        let listener = CLOUD_TWEETS.whereField("uid", in: userFollow).order(by: "timestamp", descending: true).limit(to: 20).addSnapshotListener { (querySnapshot, error) in
            
            fetchResults(tweetType: .tweet, querySnapshot: querySnapshot, error: error, completion: completion)
            
        }
        
        
        return listener
        
    }
    
    

    func fetchUserTweets(user: User, completion: @escaping([Tweet]) -> Void) -> ListenerRegistration{

        let listener = CLOUD_TWEETS.whereField("uid", in: [user.uid]).order(by: "timestamp", descending: true).limit(to: 20).addSnapshotListener { (querySnapshot, error) in
                fetchResults(tweetType: .tweet, querySnapshot: querySnapshot, error: error, completion: completion)
            }
        return listener
    }
    
    
    func fetchUserReplys(user: User, completion: @escaping([Tweet]) -> Void)  -> ListenerRegistration{

           let listener = CLOUD_REPLYS.whereField("uid", in: [user.uid]).order(by: "timestamp", descending: true).limit(to: 20).addSnapshotListener { (querySnapshot, error) in
                fetchResults(tweetType: .tweet, querySnapshot: querySnapshot, error: error, completion: completion)
            }
        return listener
    }
    
    
    func fetchLikeTweets(user: User, completion: @escaping([Tweet]) -> Void) -> ListenerRegistration{

        
       
        let listener = CLOUD_LIKES.whereField("uid", isEqualTo: user.uid).order(by: "timestamp", descending: true).limit(to: 20).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else{ return }
            var tweets = [Tweet]()
            var count = snapshot.documents.count
            
            
            for document in snapshot.documents {
            
                let dictionary = document.data() as [String : Any]
                let tweetid = dictionary["tweetid"] as! String
                let timestamp = (dictionary["timestamp"] as? Double) ?? 0.0
                 
                getTweet(tweetID: tweetid) { (tweet) in
                    
                    guard let tweet = tweet else{
                        count -= 1
                        return
                    }
                    
                    tweet.liketimestamp = Date(timeIntervalSince1970: Double(timestamp) )
                    tweets.append(tweet)
                    
                    if count == tweets.count {
                        tweets.sort{ $0.liketimestamp > $1.liketimestamp }
                        completion(tweets)
                    }
                    
                }
                
                
            }
        }
        
       return listener
    }
    
    
    
    
    
    
    
    func fetchReplys(tweet: Tweet, completion: @escaping([Tweet]) -> Void) -> ListenerRegistration {
        
          let listener =  CLOUD_REPLYS.whereField("fromtweet", isEqualTo: tweet.tweetID).order(by: "timestamp", descending: true).limit(to: 20).addSnapshotListener { (querySnapshot, error) in
                fetchResults(tweetType: .reply, querySnapshot: querySnapshot, error: error, completion: completion)
            }
        
        return listener
    }
    
    
    
    
    func setLike(tweet: Tweet, compleation: @escaping()->Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["tweetid" : tweet.tweetID,
            "uid" : uid,
            "timestamp" : Int(Date().timeIntervalSince1970)
        ] as [String : AnyObject]
        
        CLOUD_LIKES.addDocument(data: values) { _ in
            tweet.isLiked = true
            
            CLOUD_TWEETS.document(tweet.tweetID).updateData(["likes": FieldValue.increment(Int64(1)) ])
            
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
            compleation()
        }
    }
    
    
    
    
    func unsetLike(tweet: Tweet, compleation: @escaping()->Void) {
        
        checkLike(tweet: tweet) { (result, idForDelete) in
            if result {
                    guard let idForDelete = idForDelete else {
                        return
                    }
                CLOUD_LIKES.document(idForDelete).delete { error in
                    
                    CLOUD_TWEETS.document(tweet.tweetID).updateData(["likes": FieldValue.increment(Int64(-1)) ])
                    
                    NotificationService.shared.deleteNotification(type: .like, tweet: tweet)
                    
                    tweet.isLiked = false
                    compleation()
                }
            }
        }
    }
    

    
    func checkLike(tweet: Tweet, compleation: @escaping(Bool, String?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let tweetID = tweet.tweetID
        CLOUD_LIKES.whereField("tweetid", isEqualTo: tweetID).whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                let idForDelete = snapshot!.documents.first?.documentID as String?
                compleation(!(snapshot?.isEmpty ?? true), idForDelete)
            
        }
        
    }
    
    
    func tapLike(tweet: Tweet, compleation: @escaping()->Void){
        if tweet.isLiked {
            
            unsetLike(tweet: tweet) {
                compleation()
            }
            
        }else{
            setLike(tweet: tweet) {
                compleation()
            }
        }
    }
    
    
    
    fileprivate func fetchResults(tweetType: TweetType, querySnapshot: QuerySnapshot?, error: Error?, completion: @escaping([Tweet]) -> Void) {
        
        if let error = error {
            print("DEBUG: \(error.localizedDescription)")
            return
            
        }
        
        var tweets = [Tweet]()
        
        let count = querySnapshot!.documents.count
        
        if count == 0 {completion(tweets)}
     
            for document in querySnapshot!.documents {
               
                guard let dictionary = document.data() as [String: Any]? else {return}
                guard let uid = dictionary["uid"] as? String else {return}
                let tweetID = document.documentID
                
                
                
                UserService.shared.fetchUser(uid: uid) { (user) in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary, tweetType: tweetType)
                    
                        checkLike(tweet: tweet) { result, _ in
                            tweet.isLiked = result
                            tweets.append(tweet)
                           
                                
                                if count == tweets.count {
                                    tweets.sort{ $0.timestamp > $1.timestamp }
                                    completion(tweets)
                                }
                        }
                }
            }
    }
    
    
    
    
    
    fileprivate func fetchOneTweetResult(snapshot: DocumentSnapshot?, tweetType: TweetType, compleation: @escaping(Tweet?)->Void) {
        
        if !snapshot!.exists {
            compleation(nil)
        }
        
        
        guard let dictionary = snapshot?.data() as [String: Any]? else { return}
        guard let uid = dictionary["uid"] as? String else {return}
        guard let tweetID = snapshot?.documentID else {return}
        
        
        
        UserService.shared.fetchUser(uid: uid) { (user) in
            let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary, tweetType: tweetType)
            
                checkLike(tweet: tweet) { result, _ in
                    tweet.isLiked = result
                    compleation(tweet)
                }
        }
    }
    
    
}

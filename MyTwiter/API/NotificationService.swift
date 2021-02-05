import Foundation
import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    
    
    func uploadNotification(type: NotificationTweetType, tweet: Tweet? = nil, user: String? = nil){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        var values = ["timestamp": Int(Date().timeIntervalSince1970),
                      "type": type.rawValue,
                      "uid": currentUid
        ] as [String: AnyObject]
        
        
        if let tweet = tweet {
            
          
            values["tweetID"] = tweet.tweetID as AnyObject
            values["notifeUserUid"] = tweet.user.uid as AnyObject
            
            CLOUD_NOTIFICATION.addDocument(data: values)
        
            
        }else if let user = user {
            
            values["notifeUserUid"] = user as AnyObject
            CLOUD_NOTIFICATION.addDocument(data: values)
            
            
        }
        
        
    }
    
    
    func deleteNotification(type: NotificationTweetType, tweet: Tweet? = nil, user: String? = nil){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if let tweet = tweet {
            CLOUD_NOTIFICATION.whereField("tweetID", isEqualTo: tweet.tweetID).whereField("notifeUserUid", isEqualTo: tweet.user.uid).whereField("uid", isEqualTo: currentUid).whereField("type", isEqualTo: type.rawValue).getDocuments { (snapshot, error) in
               
                 snapshot?.documents.forEach{  CLOUD_NOTIFICATION.document($0.documentID).delete() }
            }
        }else if let user = user {
            CLOUD_NOTIFICATION.whereField("notifeUserUid", isEqualTo: user).whereField("uid", isEqualTo: currentUid).whereField("type", isEqualTo: type.rawValue).getDocuments { (snapshot, error) in
               
                 snapshot?.documents.forEach{  CLOUD_NOTIFICATION.document($0.documentID).delete() }
            }
        }
        
    }
    
    
    func getNotifications(forUserUid uid: String? = nil, compleation: @escaping([NotificationTweet])->Void) -> ListenerRegistration? {
        
        var uidUser: String
        
        if uid == nil {
            guard let currentUserUid = Auth.auth().currentUser?.uid else {return nil}
            uidUser = currentUserUid
        }else{
            uidUser = uid!
        }
        
       let listener =  CLOUD_NOTIFICATION.whereField("notifeUserUid", isEqualTo: uidUser).order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            var notises = [NotificationTweet]()
            let count = snapshot.documents.count
            
            if count == 0 { compleation(notises) }
            
            for document in snapshot.documents {
                guard let dictionary = document.data() as [String : Any]? else { return }
                
               
                
                
                if let tweetID = dictionary["tweetID"] as? String {
                   
                    TweetService.shared.getTweet(tweetID: tweetID) { tweet in
                       let uid = dictionary["uid"] as! String
                       
                        UserService.shared.fetchUser(uid: uid) { user in
                            let notice = NotificationTweet(user: user, tweet: tweet, dictionary: dictionary)
                            notises.append(notice)
                             compleationNotification(count: count, notises: notises, compleation: compleation)
                        }
                    }
                }else{
                    let uid = dictionary["uid"] as! String
                        print(uid)
                        UserService.shared.fetchUser(uid: uid) { user in
                            notises.append(NotificationTweet(user: user, dictionary: dictionary))
                            compleationNotification(count: count, notises: notises, compleation: compleation)
                        }
                }

                
            }
            
            
        }
        
        return listener
    }
    
    
    func compleationNotification(count: Int, notises: [NotificationTweet], compleation: @escaping([NotificationTweet])->Void){
        var newNotices = notises
        newNotices.sort{ $0.timestamp > $1.timestamp }
       
      
       if (count - 1) == newNotices.count {
           compleation(newNotices)
       }
    }
    
    
    
    
}

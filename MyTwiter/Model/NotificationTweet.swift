import Foundation


enum NotificationTweetType: Int{
    case follow
    case like
    case reply
    case retweet
    case mention
}


struct NotificationTweet{
    let user: User
    var timestamp: Date!
    var tweet: Tweet?
    var type: NotificationTweetType?
    
    
    init(user: User, tweet: Tweet? = nil, dictionary: [String: Any]){
        
        self.user = user
        self.tweet = tweet
        
  
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationTweetType(rawValue: type)
        }
        
    }
    
    
}

import Foundation

enum TweetType{
    case tweet
    case reply
    case retweet
}


class Tweet{
    
    let caption: String
    let tweetID: String
    let uid: String
    let likes: Int
    var timestamp: Date!
    let retweetCount: Int
    let user: User
    var countReply: Int = 0
    var isLiked = false
    let tweetType: TweetType
    var liketimestamp: Date!
    var replyToUsername: String?
    
    init (user: User, tweetID: String, dictionary: [String: Any], tweetType: TweetType){
        
        self.tweetID = tweetID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        self.tweetType = tweetType
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        
        if let replyToUsername = dictionary["replyToUsername"] as? String {
            self.replyToUsername = replyToUsername
        }
        

    }

}

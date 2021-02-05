import UIKit



struct UploadTweetViewModel {
    
    
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplayLabel: Bool
    var replyText: NSAttributedString?
    
    
    
    
    
    
    init(config: UploadTweetConfiguration){
        switch config {
            case.tweet:
                self.actionButtonTitle = "Tweet"
                self.placeholderText = "What's happenning"
                self.shouldShowReplayLabel = false
            case .retweet(let forTweet):
                self.actionButtonTitle = "Reply "
                self.placeholderText = "Tweet your reply"
                self.shouldShowReplayLabel = true
                
                let nsString = NSMutableAttributedString(string: "Reprying to ", attributes: [.foregroundColor: UIColor.lightGray, .font : UIFont.systemFont(ofSize: 14)])
                nsString.append(NSAttributedString(string: "@" + forTweet.user.username, attributes: [.foregroundColor: UIColor.twitterBlue, .font : UIFont.systemFont(ofSize: 14)]))
                

                self.replyText = nsString
        }
    }
     
    
    
    
}

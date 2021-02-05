import UIKit


class NotificationViewModel {
    
    let notification: NotificationTweet
    
    var labelNotification: NSAttributedString {
        let atrString = NSMutableAttributedString(string: "@" + notification.user.username + " ", attributes: [.foregroundColor : UIColor.twitterBlue, .font : UIFont.boldSystemFont(ofSize: 13)])
        
        
        
        
        if let type = notification.type {
            switch type {
         
                case .follow:
                    atrString.append(NSAttributedString(string: "followed you", attributes: [.foregroundColor : UIColor.black, .font : UIFont.systemFont(ofSize: 13)]))
                case .like:
                    atrString.append(NSAttributedString(string: "like your tweet", attributes: [.foregroundColor : UIColor.black, .font : UIFont.systemFont(ofSize: 13)]))
                case .reply:
                    atrString.append(NSAttributedString(string: "reply for your tweet", attributes: [.foregroundColor : UIColor.black, .font : UIFont.systemFont(ofSize: 13)]))
                case .retweet:
                    atrString.append(NSAttributedString(string: "make retweet", attributes: [.foregroundColor : UIColor.black, .font : UIFont.systemFont(ofSize: 13)]))
                case .mention:
                    atrString.append(NSAttributedString(string: "mention you", attributes: [.foregroundColor : UIColor.black, .font : UIFont.systemFont(ofSize: 13)]))
                }
        }
        
        return atrString
    }
    
    
    init(notification: NotificationTweet){
        self.notification = notification
    }
    
    
    
    func actionButtonTitle(button: UIButton) {
        
       
        if self.notification.type != .follow {
            
                button.isHidden = true
            
            }else{
                
                button.isHidden = false
                
                if notification.user.isFollowed {
                    button.setTitle("Following", for: .normal)
                }
                else{
                    button.setTitle("Follow", for: .normal)
                }
                
            }
    }
    
    
    
    func setImageProfile(forImageView iv: UIImageView){
        iv.sd_setImage(with: notification.user.profileImageUrl, completed: nil)
    }
    
    
}

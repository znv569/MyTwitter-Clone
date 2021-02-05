import UIKit




class TweetViewModel{
    var tweet: Tweet
    
    
    
    var buttonComment: (Int)->Void = { _ in
        
    }
    
    var user: User{
            return tweet.user
    }
    
    
    
    var fullname: String {
        return user.fullname
    }
    
    var username: String {
        return "@" + user.username
    }
    
    var caption: String {
        return tweet.caption
    }
    var likes: NSAttributedString{
        return Utilites.shared.attributedText(withCount: tweet.likes, text: "likes")
    }
    
    var retweets: NSAttributedString{
        return Utilites.shared.attributedText(withCount: tweet.retweetCount, text: "retweets")
    }
    
    func setReplys(label: UILabel){
        

            TweetService.shared.getAllReplys(id: tweet.tweetID) { replys in
                let count  = replys.count - 1
                label.attributedText = Utilites.shared.attributedText(withCount: count, text: "replys")
            }
     
        
        
    }
    

    
    var timestamp: String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    
    
    var fullTimestamp: String{
         let dateFormatterGet = DateFormatter()
         dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatterGet.string(from: tweet.timestamp)
    }
    
    
    var userInfoText: NSAttributedString {
        
        let title =  NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username) - \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return title
        
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    func setProfileImage(imageView: UIImageView){
        imageView.sd_setImage(with: profileImageUrl, completed: nil)
    }
    
    
    
    init(tweet: Tweet){
        self.tweet = tweet
   
    }
    
    
    
    func setLikesButton(buttton: UIButton){
        if !tweet.isLiked {
            buttton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            buttton.tintColor = .darkGray
        }else{
            buttton.setImage(#imageLiteral(resourceName: "like_filled"), for: .normal)
            buttton.tintColor = .systemRed
        }
    }
    
    
    func setReplys(buttonForTextCount button: UIButton, time: Double){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            TweetService.shared.getAllReplys(id: self.tweet.tweetID) { replys in
                let count  = replys.count - 1
                button.setTitle(String(count), for: .normal)
            }
        }
    }
    
    
    
    func setFromReplyUsername(label: UILabel, heightConstarint: NSLayoutConstraint){
        
        if let replyUser = tweet.replyToUsername {
            
            let attrText = NSMutableAttributedString(string: "🤙🏼 ", attributes: [
                                                                                         .font : UIFont.systemFont(ofSize: 13)])
            attrText.append(NSAttributedString(string: "replying to ", attributes: [
                                                                                     .font : UIFont.systemFont(ofSize: 13)]))
            attrText.append(NSAttributedString(string: "@" + replyUser, attributes: [.foregroundColor : UIColor.twitterBlue,
                                                                                     .font : UIFont.systemFont(ofSize: 13)]))
            label.attributedText = attrText
            label.isHidden = false
            heightConstarint.constant = 20
        }else{
            heightConstarint.constant = 0
            label.isHidden = true
        }
        
    }
    
    
    
 
    
    
    
    func size(forWidth width: CGFloat, forSizeFont font: UIFont) -> CGSize{
        let label = UILabel()
        label.font = font
        label.text = tweet.caption
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.numberOfLines = 0
        
        var height = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if  tweet.replyToUsername != nil {
            height.height += 20
        }
        return height
    }
    
    
    
}

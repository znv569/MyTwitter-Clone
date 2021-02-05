import UIKit




enum ProfileFilterOption: Int, CaseIterable {

    
    case tweets
    case replies
    case likes
    
    
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}






class ProfileHeaderViewModel {
    
    
    
    private let user: User

    
    
    var fullname: String {
        return user.fullname
    }
    
    var username: String {
        return "@" + user.username
    }
    
    
    var bio: String {
        return user.bio
    }
    

    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    
    init(user: User) {
        
        
        self.user = user
        
      
    
        
        
    }
    
    func actionButtonTitle(button: UIButton) {
        
       
            if self.user.isCsurrentUser {
                 button.setTitle("Edit Profile", for: .normal)
            }else{
                if user.isFollowed {
                    button.setTitle("Unfollow", for: .normal)
                }
                else{
                    button.setTitle("Follow", for: .normal)
                }
            }
    }
    
    
    
    
    func followCountSet(following: UILabel, followers: UILabel, color: UIColor? = nil){
        
        UserService.shared.userStats(uid: user.uid) {  (userStat) in
            followers.attributedText = Utilites.shared.attributedText(withCount: userStat.followers, text: "followers", color: color)
            following.attributedText = Utilites.shared.attributedText(withCount: userStat.following, text: "following", color: color)
        }
        
        
    }
    
    
    
   
    
    

    
}

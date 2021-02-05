import Foundation
import Firebase


class User{
    var fullname: String
    var email: String
    var username: String
    var profileImageUrl: URL?
    let uid: String
    var isCsurrentUser: Bool
    var isFollowed: Bool
    var bio: String
    var follow: [String]?
    
    
    init(uid: String, dictionary: [String: AnyObject], isFollowed: Bool){

        self.uid = uid
        
        
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        
        let profileImageUrlString = dictionary["profileImageUrl"] as? String ?? ""
        self.profileImageUrl = URL(string: profileImageUrlString)
        
        
        let curUserUid = Auth.auth().currentUser?.uid
        self.isCsurrentUser =  (uid == curUserUid!)
        self.isFollowed = isFollowed
        
        
        if let follow = dictionary["follow"] as? [String]{
            self.follow = follow
        }
        
        self.bio = dictionary["bio"] as? String ?? ""
        
        
    }
    
    
    
}



struct UserFollowStat {
    var following: Int
    var followers: Int
}

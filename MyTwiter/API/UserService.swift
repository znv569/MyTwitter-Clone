import UIKit
import Firebase

struct UserService{
    static let shared = UserService()
    
    func fetchUser(uid: String, compleation: @escaping(User) -> Void){
        
            CLOUD_USERS.document(uid).getDocument { (document, error) in
                
            guard let dictionary = document?.data() as [String: AnyObject]? else { return }
            
                checkFollow(uid: uid) { (check) in
                    let user = User(uid: uid, dictionary: dictionary, isFollowed: check)
                    compleation(user)
                }
        }
        
    }
    
    
    
    
    func fetchUser(username: String, compleation: @escaping(User) -> Void){
            
        
     
        
        CLOUD_USERS.whereField("username", isEqualTo: username).getDocuments(completion: { (snapshot, error) in
    
            
            if let document = snapshot?.documents.first {
                guard let dictionary = document.data() as [String : AnyObject]? else { return }
                let uid = document.documentID
                checkFollow(uid: uid) { (check) in
                    let user = User(uid: uid, dictionary: dictionary, isFollowed: check)
                   compleation(user)
                    
                }
            }
            
        })
        
        
            
      
        
    }
    
    
    
    
    func fetchUsers(query: String? = nil, compleation: @escaping([User]) -> Void){
        
        var dbQuery: Query
        
        if let query = query, query != "" {
            
            dbQuery = CLOUD_USERS.whereField("username", isGreaterThanOrEqualTo:  "\(query)").whereField("username", isLessThanOrEqualTo:  "\(query)~")
        }else{
            dbQuery = CLOUD_USERS
        }
        
        
    
        
        dbQuery.getDocuments { (snapshot, error) in
            
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            var users = [User]()
           
            
                for document in snapshot!.documents {
                   
                    guard let dictionary = document.data() as [String: AnyObject]? else { return }
                    let uid = document.documentID
                    checkFollow(uid: uid) { (check) in
                        let user = User(uid: uid, dictionary: dictionary, isFollowed: check)
                        users.append(user)
                        compleation(users)
                    }
                }
            
           
            
        }
        
    }
    
    typealias CompleationBlock = (Error?) -> Void
    
    
    func checkFollow(uid: String, checkResult: @escaping(Bool)->Void){
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        var follow = [String]()
        
        
        
        
        CLOUD_USERS.document(currentUser).getDocument {  (document, error) in
            
        
            guard let dictionary = document?.data() as [String: Any]? else {return}
            follow = (dictionary["follow"] as? NSArray) as? [String] ?? []
            
            checkResult( follow.contains(uid) )
            
        }
       
      
      
    }
    
    
    
    func followUser(uid: String, compleation: @escaping(CompleationBlock)){
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        
        
       CLOUD_USERS.document(currentUser).updateData(["follow": FieldValue.arrayUnion([uid])], completion: compleation)
        
       NotificationService.shared.uploadNotification(type: .follow, user: uid)
      
    }
    
    
    func unfolllowUser(uid: String, compleation: @escaping(CompleationBlock)){
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        CLOUD_USERS.document(currentUser).updateData(["follow": FieldValue.arrayRemove([uid])], completion: compleation)
        NotificationService.shared.deleteNotification(type: .follow, user: uid)
    }
    
    
    func userStats(uid: String, compleation: @escaping(UserFollowStat) -> Void){

        CLOUD_USERS.whereField("follow", arrayContains: uid).getDocuments { (query, error) in
            let countFollowes = query?.count ?? 0
            
            CLOUD_USERS.document(uid).getDocument {  (document, error) in
                
            
                guard let dictionary = document?.data() as [String: Any]? else {return}
                let following = (dictionary["follow"] as? NSArray) as? [String] ?? []
                let userFollow = UserFollowStat(following: following.count, followers: countFollowes)
                
                compleation(userFollow)
            }
            
            
        }
    }
    
    func updateUser(image: UIImage?, fullname: String?, username: String?, bio: String?, user: User, compleation: @escaping(User) -> Void){
        var value = [String: Any]()
        
        
        
        if let fullname = fullname {
            value["fullname"] = fullname
            user.fullname = fullname
        }
        
        if let bio = bio {
            value["bio"] = bio
            user.bio = bio
        }
        
        if let username = username {
            value["username"] = username
            user.username = username
        }
        
        
        
        if let image = image {
            
            
            guard let imageData = image.jpegData(compressionQuality: 0.3) else{ return }
            let filemane = NSUUID().uuidString
            let storageRef = STORAGE_PROFILE_IMAGES.child(filemane)
            
            storageRef.putData(imageData, metadata: nil) { (meta, error) in
                storageRef.downloadURL { (url, error) in
                    
                    guard let profileImageUrl = url?.absoluteString else {return}
                    user.profileImageUrl = URL(string: profileImageUrl)
                 
                    value["profileImageUrl"] = profileImageUrl
                    
                    CLOUD_USERS.document(user.uid).updateData(value) { _ in
                        compleation(user)
                    }
                }
            }
        }else{
            CLOUD_USERS.document(user.uid).updateData(value) { _ in
                compleation(user)
            }
            
        }
        
    }
    
    
}

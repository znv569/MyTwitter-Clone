 import UIKit
 import Firebase
 
 
 struct  AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
 }
 
 struct AuthService{
    
    
    //синглтон
    static let shared = AuthService()
    
    var currentUser:  FirebaseAuth.User?{
      return Auth.auth().currentUser
    }

    
    func logUserOut(){
        do {
            try  Auth.auth().signOut()
        }catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func logUserIn(withEMail email: String, password: String, compleation: @escaping(AuthDataResult?, Error?) -> Void){
        
        
        Auth.auth().signIn(withEmail: email, password: password, completion: compleation)
        
        
    }
    
    func registerUser(credential: AuthCredentials, compleation: @escaping(Error?) -> Void){
        
        let email = credential.email
        let profileImage = credential.profileImage
        let fullname = credential.fullname
        let username = credential.username
        let password = credential.password
        
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else{ return }
        let filemane = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filemane)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    if error != nil {
                        return
                    }
                    
                    
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    CLOUD_USERS.document(uid).setData(values, completion: compleation)
                    
                }
            }
            
            
            
        }
    }
 }

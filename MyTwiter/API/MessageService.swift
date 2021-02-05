import Foundation
import Firebase


class  MessageService{
    
    
    static let shared = MessageService()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var currentUserUid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    
    
    
    
    func getChats(compleation: @escaping([Chat]) -> Void) -> ListenerRegistration?{
        guard let currentUserUid = currentUserUid else { return nil}
        
        let listener = CLOUD_USERS.document(currentUserUid).collection("chats").order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            var chats = [Chat]()
            
            let count = snapshot.documents.count
            
            
            
            for document in snapshot.documents {
                
                guard  let dictionary = document.data() as [String: Any]? else {return}
                
               
                
                UserService.shared.fetchUser(uid: document.documentID) { user in
                    
                    let chat = Chat(fromUser: user, dictionary: dictionary)
                    
                    self.notificateChat(chat: chat)
                    
                    chats.append(chat)
                    
                    chats.sort{$0.timestamp > $1.timestamp}
                    
                    if count == chats.count {
                        compleation(chats)
                    }
                }
                 
                
                
            }
            
        }
        return listener
    }
    
    
    
    func getMessages(chat: Chat, compleation: @escaping ([Message]) -> Void) -> ListenerRegistration?{
        guard let currentUserUid = currentUserUid else {return nil  }
        
        let listener = CLOUD_USERS.document(currentUserUid).collection("chats").document(chat.fromUser.uid).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            let count = snapshot.documents.count
            var messages = [Message]()
            
            for document in snapshot.documents {
                
                guard let dictionary = document.data() as [String: Any]? else { return }
                let message = Message(dictionary: dictionary)
                
                messages.append(message)
                messages.sort{$0.timestamp < $1.timestamp }
                
                if count == messages.count {
                    compleation(messages)
                    self.readChat(chat: chat)
                }
                
            }
        
        
        }
        
        return listener
    }
    
    
    
    
    func sendMessage(toUser: User, message: String){
        guard let currentUserUid = currentUserUid else { return  }
        let nowTimestamp = Int(Date().timeIntervalSince1970)
        
        var chatValue = [String: Any]()
        chatValue["readed"] = true
        chatValue["lastMessage"] = message
        chatValue["timestamp"] = nowTimestamp
        chatValue["notificate"] = true
        
        var messageValue = [String: Any]()
        messageValue["inbox"] = false
        messageValue["message"] = message
        messageValue["type"] = 0
        messageValue["timestamp"] = nowTimestamp
        
      
            
    
        CLOUD_USERS.document(currentUserUid).collection("chats").document(toUser.uid).setData(chatValue) { [messageValue] error in
            CLOUD_USERS.document(currentUserUid).collection("chats").document(toUser.uid).collection("messages").addDocument(data: messageValue)
        }
        
        messageValue["inbox"] = true
        chatValue["readed"] = false
        chatValue["notificate"] = false
        
        CLOUD_USERS.document(toUser.uid).collection("chats").document(currentUserUid).setData(chatValue) { error in
            CLOUD_USERS.document(toUser.uid).collection("chats").document(currentUserUid).collection("messages").addDocument(data: messageValue)
        }
            

        
        
    }
    
    
    
    func readChat(chat: Chat){
        guard let currentUserUid = currentUserUid else { return  }
        chat.readed = true
        CLOUD_USERS.document(currentUserUid).collection("chats").document(chat.fromUser.uid).updateData(["readed": true])
    }
    
    
    
    func notificateChat(chat: Chat){
        guard let currentUserUid = currentUserUid else { return  }
        if(!chat.notificate){
            
            chat.notificate = true
            CLOUD_USERS.document(currentUserUid).collection("chats").document(chat.fromUser.uid).updateData(["notificate": true])
            appDelegate.notificate.newMessage(title: "New message from " + chat.fromUser.fullname, mess: chat.lastMessage, identifire: chat.lastMessage, url: chat.fromUser.profileImageUrl)
            
        }
    }
    
    
    
}

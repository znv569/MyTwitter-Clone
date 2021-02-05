import Foundation
import Firebase


class Chat {
    

    var fromUser: User
    var lastMessage: String
    var timestamp: Date
    var readed: Bool
    var notificate: Bool
    
    init(fromUser user: User, dictionary: [String: Any]) {
        
        self.fromUser = user
        self.timestamp = Date(timeIntervalSince1970: dictionary["timestamp"] as? Double ?? 0.0)
        self.lastMessage = dictionary["lastMessage"] as? String ?? ""
        self.readed = dictionary["readed"] as? Bool ?? false
        self.notificate = dictionary["notificate"] as? Bool ?? true
        
    }
    
}


class Message {
    
    let timestamp: Date
    let message: String?
    let inbox: Bool
    let type: TypeMessage
    
    
    init(dictionary: [String: Any]) {
        
        
        let typeNum = dictionary["type"] as? Int ?? 0
        self.type = TypeMessage.init(rawValue: typeNum)!
        self.timestamp = Date(timeIntervalSince1970: dictionary["timestamp"] as? Double ?? 0.0)
        self.inbox = dictionary["inbox"] as? Bool ?? false
        
        switch type {
            case .text:
                self.message = dictionary["message"] as? String ?? ""
        }
        
        
        
    }
}



enum TypeMessage: Int, CaseIterable {
    case text
}

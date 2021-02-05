import UIKit




class EditProfileViewModel {
    
    let user: User
    let option: EditProfileOption
    
    
    var nameField: String {
        return option.description()
    }
    
    
    var valueDefault: String {
        switch option{
            case .fullname:
                return user.fullname
                
            case .username:
                return user.username
                
            case .bio:
                return user.bio
        }
    }
    
    var showInputField: Bool{
        return option == .bio
    }
    
    
    var showInputView: Bool{
        return option != .bio
    }
    
    
    
    init(user: User, option: EditProfileOption) {
        self.user = user
        self.option = option
    }
    
    
    
    
}




enum EditProfileOption: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    
    
    func description() -> String {
        switch self {

        case .fullname:
            return "Fullname"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        }
        
    }
    
}

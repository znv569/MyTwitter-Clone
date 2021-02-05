import Foundation
import SwiftIconFont


enum LeftMenuOption: Int, CaseIterable{
    
    case profile
    case logout
    
    
    var description: String{
        switch self {
            case .profile:
              return "Edit your profile"
            case .logout:
              return "LogOut"
        }
    }
    
    
    var icon: UIImage {
        var image = UIImage()
      
        
        switch self {

            case .profile:
             
                image = UIImage(from: .fontAwesome5Solid, code: "user", textColor: .white, backgroundColor: .clear, size: CGSize(width: 20, height: 20))
            case .logout:
                image = UIImage(from: .fontAwesome5Solid, code: "sign-out-alt", textColor: .white, backgroundColor: .clear, size: CGSize(width: 20, height: 20))
                
            }
        return image
    }
    
}

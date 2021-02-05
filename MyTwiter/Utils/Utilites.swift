import UIKit


class Utilites{
    
    static let shared = Utilites()
    
    func inputContainer(withImage image: UIImage, textField: UITextField) -> UIView {
        
        
        
        let view = UIView()
        
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
 
        let iv = UIImageView()
        iv.image = image
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
  
        
        
        return view
    }
    
    func textField(withPlaceHolder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.tintColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
    
    
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
    
    
    func attributedText(withCount value: Int, text: String, color: UIColor? = nil) -> NSAttributedString{
        
        
        let atrString = NSMutableAttributedString(attributedString: NSAttributedString(string: " \(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        var attr = [.font : UIFont.systemFont(ofSize: 14)] as [NSAttributedString.Key: Any]
        if let color = color {
            attr[.foregroundColor] = color
        }else{
            attr[.foregroundColor] = UIColor.lightGray
        }
        atrString.append(NSAttributedString(string: " \(text)", attributes: attr))
       
        
        return atrString
    }
    
    
    
    func presentUpload(config: UploadTweetConfiguration, target: UIViewController){
        guard let currentUser = AuthService.shared.currentUser else { return}
        UserService.shared.fetchUser(uid: currentUser.uid) { (user) in
            let controllerUpload = UploadTweetsController(user: user, configure: config)
            let nav = UINavigationController(rootViewController: controllerUpload)
            nav.modalPresentationStyle = .fullScreen
            target.present(nav, animated: true, completion: nil)
        }
    }
    
    
    enum GenerateType {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
    }
    
    
    func generator(generateType: GenerateType){
        DispatchQueue.global(qos: .utility).async {
          
            
                   switch generateType {
                   case .error:
                       let generator = UINotificationFeedbackGenerator()
                       generator.notificationOccurred(.error)

                   case .success:
                       let generator = UINotificationFeedbackGenerator()
                       generator.notificationOccurred(.success)

                   case .warning:
                       let generator = UINotificationFeedbackGenerator()
                       generator.notificationOccurred(.warning)

                   case .light:
                       let generator = UIImpactFeedbackGenerator(style: .light)
                       generator.impactOccurred()

                   case .medium:
                       let generator = UIImpactFeedbackGenerator(style: .medium)
                       generator.impactOccurred()

                   case .heavy:
                       let generator = UIImpactFeedbackGenerator(style: .heavy)
                       generator.impactOccurred()
            
                   }
               
        }
        
    }
    
    
}

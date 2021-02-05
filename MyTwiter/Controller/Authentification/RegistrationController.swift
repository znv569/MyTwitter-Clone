import UIKit
import Firebase

class RegistrationController: UIViewController {
    //MARK: - Properties
    
    
    
    private var profileImage: UIImage?
    
    
    private let imagePicker = UIImagePickerController()
    
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfile), for: .touchUpInside)
        button.setDimensions(width: 128, height: 128)
        return button
    }()
    
    
    private let alreadyHaveAccountButton: UIButton = {
        let but = Utilites().attributedButton("Alredy have an account?", " Log In")
        but.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return but
    }()

    
    
    
    private lazy var emailContainer: UIView = {
     
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        return Utilites().inputContainer(withImage: image, textField: emailTextField)
        
        
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilites().textField(withPlaceHolder: "Email")
        tf.textContentType = .emailAddress
        return tf
    }()
    
    
    private lazy var passContainer: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        return Utilites().inputContainer(withImage: image, textField: passwordTextField)
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilites().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = false
        return tf
    }()
    
    
    
    
    private lazy var fullNameContainer: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        
        return Utilites().inputContainer(withImage: image, textField: fullNameTextField)
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = Utilites().textField(withPlaceHolder: "Full Name")
        tf.textContentType = .familyName
        return tf
    }()
    
    
    
    
    private lazy var usernameContainer: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        return Utilites().inputContainer(withImage: image, textField: usernameTextField)
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilites().textField(withPlaceHolder: "Username")
        return tf
    }()
    
    
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()

   
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    
    
    //MARK: - Selectors
    
    @objc func handleShowLogin(button: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp(button: UIButton){
        guard let profileImage = profileImage else {return}
        guard let email = emailTextField.text else { return   }
        guard let password = passwordTextField.text else { return   }
        guard let fullname = fullNameTextField.text else {  return  }
        guard let username = usernameTextField.text?.lowercased() else { return  }
        
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        AuthService.shared.registerUser(credential: credentials) { (error) in
            
            guard let tab = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabController else { return }
  
            tab.authentificateUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @objc func handleAddProfile(button: UIButton){
        present(imagePicker, animated: true, completion: nil)
       
        
    }
    
    
    lazy var scrollView = UIScrollView()
    
    
    
    
    
    //MARK: - Helpers
    
    
    func configureUI (){
        
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
       
        
        scrollView.backgroundColor = .twitterBlue
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        scrollView.addSubview(plusPhotoButton)
        plusPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        plusPhotoButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 130).isActive = true
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainer, passContainer, fullNameContainer, usernameContainer, signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
       
        scrollView.addSubview(stack)
        
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: scrollView.leftAnchor, right: view.rightAnchor , paddingTop: 40, paddingLeft: 32, paddingRight: 32)
        
        scrollView.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor( left: scrollView.leftAnchor, bottom: scrollView.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 20)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    @objc func kbDidShow(notification: Notification){

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
               let keyboardHeight = keyboardRectangle.height
            
            (self.scrollView).contentSize = CGSize(width: self.scrollView.bounds.width, height: self.scrollView.bounds.height + keyboardHeight)
            (self.scrollView).horizontalScrollIndicatorInsets.bottom = keyboardHeight
           }
    }
    @objc func kbDidHide(notification: Notification){
        self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
    }
}


// MARK: - UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else{
            return
        }
        self.profileImage = profileImage
        
        plusPhotoButton.layer.cornerRadius = 128 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
        
        
    }
}

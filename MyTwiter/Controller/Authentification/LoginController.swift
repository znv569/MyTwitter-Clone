import UIKit


class LoginController: UIViewController {
    //MARK: - Properties
    
    private let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    private lazy var emailContainer: UIView = {
     
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        return Utilites().inputContainer(withImage: image, textField: emailTextField)
        
        
    }()
    
    private lazy var passContainer: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        return Utilites().inputContainer(withImage: image, textField: passwordTextField)
    }()
    
    
    private let emailTextField: UITextField = {
        let tf = Utilites().textField(withPlaceHolder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilites().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    private let dontHaveAccountButton: UIButton = {
        let but = Utilites().attributedButton("Don't have an account?", " Sign Up")
        but.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return but
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    
    @objc func handleLogin(button: UIButton){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
       

        
        AuthService.shared.logUserIn(withEMail: email, password: password) {[weak self] (result, error) in
            if let error = error{
                
                print("DEBUG: \(error.localizedDescription)")
                return
 
            }
            
            
            guard let tab = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabController else {
                print("DEBUG: ошибка")
                return }
            
            tab.authentificateUserAndConfigureUI()
            self?.dismiss(animated: true, completion: nil)
            
        }
 
    }
    
    @objc func handleShowSignUp(button: UIButton){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Helpers
    
    
    func configureUI (){
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainer, passContainer, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 32, paddingRight: 32)
        
        
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor( left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 20)
        

        
    }
}

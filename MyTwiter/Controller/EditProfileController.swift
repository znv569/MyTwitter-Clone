import UIKit


private let reusebleCell = "EditProfileCell"



class EditProfileController: UITableViewController {
    
    
    //MARK: Properties
    private let user: User
    private let imagePicker = UIImagePickerController()
    private let reusebleHeader = "EditProfileHeader"
    private lazy var headerView = EditProfileHeader(user: user)
    
    
    
    private var imageSelected: UIImage?{
        didSet{
            headerView.imageProfile.image = imageSelected
        }
    }
    
    private var fullname: String?
    private var username: String?
    private var bio: String?

    
    
    //MARK: Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureTableView()
       
    }
    
    
    //MARK: Helpers
    func configureNavigation(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handlerCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handlerSave))
        navigationItem.title = "Edit profile"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    
    func configureTableView(){
        view.backgroundColor = .white
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reusebleCell)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    //MARK: Selectors
    
    @objc func handlerCancel(){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlerSave(){
        
        UserService.shared.updateUser(image: imageSelected, fullname: fullname, username: username, bio: bio, user: user){ user in
            self.handlerCancel()
        }
        
        
    }
    
}


//MARK: UITableViewDelegate UITableViewDataSource
extension EditProfileController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusebleCell) as! EditProfileCell
        guard let option = EditProfileOption(rawValue: indexPath.row) else {return cell}
        
        cell.option = option
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let option = EditProfileOption.init(rawValue: indexPath.row)
        return option == .bio ? 100 : 48
    }

    
    


}



extension EditProfileController: EditProfileHeaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleChangeImage(imageViewProfile: UIImageView) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.imageSelected = image
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EditProfileCell
        cell.focusInput()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}


extension EditProfileController: EditProfileCellDelegate {
    func updateValueText(option: EditProfileOption, value: String) {
        switch option {
            case .fullname:
                self.fullname = value
            case .username:
                self.username = value
            case .bio:
                self.bio = value
        }

        
    }
    
    
}

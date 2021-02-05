import UIKit
import Firebase
private let reusebleLeftCell = "LeftMenuCell"


class LeftMenuController: UITableViewController {
    //MARK: Properties
    private let user: User
    
    private lazy var headerTableView = LeftMenuHeader(user: user, frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
    
    //MARK: Lifecycle
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    
    //MARK: Helpers
    func configureUI(){
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerTableView
        tableView.register(LeftMenuCell.self, forCellReuseIdentifier: reusebleLeftCell)
        
    }
    
    
    //MARK: Selectors
    
}




//MARK: TableVIEW Delegate DataSource
extension LeftMenuController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LeftMenuOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusebleLeftCell) as! LeftMenuCell
        let option = LeftMenuOption.init(rawValue: indexPath.row)
        cell.option = option
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = LeftMenuOption(rawValue: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let tab = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabController else { return }
            
        dismiss(animated: true, completion: nil)
        
        switch option {
            case .logout:
                AuthService.shared.logUserOut()
                tab.authentificateUserAndConfigureUI()
            case .profile:
                let controller = EditProfileController(user: user)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                tab.present(nav, animated: true, completion: nil)
            default:
              print("Неизвестный пункт меню")
        }
        
    }
}

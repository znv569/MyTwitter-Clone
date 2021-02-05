import UIKit
import Firebase

private let reusebleCell = "NotificationCell"



class NotificationsController: UITableViewController {
    
    
    // MARK: - Properies
    
    
    private var notificatios: [NotificationTweet]?{
        didSet(oldValue){
            tableView.reloadData()
        
        }
    }
    
    private var listener: ListenerRegistration?
    

    // MARK: - Lifecycle

    
    init() {
        super.init(style: .plain)
        configureUI()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotification()
    }
    
    
    
    
    
    func fetchNotification(){
        tableView.refreshControl?.beginRefreshing()
        listener?.remove()
        
        listener = NotificationService.shared.getNotifications { notifications in
            self.notificatios = notifications
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    
    

    //MARK: - Helpers
    func configureUI(){
        
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reusebleCell)
        tableView.allowsSelection = false
        view.backgroundColor = .red
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        tableView.separatorStyle = .none
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
        
    }
    
    //MARK: Selectors
    
    @objc func handleRefresh(){
        fetchNotification()
    }
    
}


//MARK: TABLEVIEW Delegate DataSource

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificatios?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusebleCell) as! NotificationCell
        
        cell.notification = notificatios![indexPath.row]
        cell.delegate = self
        
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

}






//MARK: NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate{
    func tappedFollowButton(_ cell: NotificationCell) {
        let uid = cell.notification?.user.uid
    
        UserService.shared.checkFollow(uid: uid!){ checks in
                               
                if cell.notification!.user.isCsurrentUser {
                                
                                }else{
                                    if !checks {
                                        UserService.shared.followUser(uid: uid!){ _ in
                                            cell.notification?.user.isFollowed = true
                                            cell.configure()
                                        }
                                        
                                    }else{
                                        
                                        UserService.shared.unfolllowUser(uid: uid!) { _ in
                                            cell.notification?.user.isFollowed = false
                                            cell.configure()
                                        }
                                    }
                            }
             }
    }
    
  
    
    
    func tappedProfileImage(user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

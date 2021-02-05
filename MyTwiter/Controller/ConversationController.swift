import UIKit
import Firebase



private let reusebleCellChat = "ChatCell"
private let reusebleUserCell = "UserCell"



enum ConversationCellType: Int, CaseIterable {
    case message
    case user
}


class ConversationController: UITableViewController {
    
    
    // MARK: - Properies
    
    private var chats = [Chat](){
        didSet{
            tableView.reloadData()
        }
    }
    
    private var listener: ListenerRegistration?
    
    var user: User?{
        didSet{
          fetchChats()
        }
    }
    
    private var userList = [User]()
    
    private var optionCell: ConversationCellType = .message{
        didSet{
            tableView.reloadData()
        }
    }
    
    
    private let refresh = UIRefreshControl()

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
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let indexSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexSelectedRow, animated: true)
            tableView.reloadRows(at: [indexSelectedRow], with: .none)
        }
        
        
    }
    


    //MARK: - Helpers
    
    func configureUI(){
        
        view.backgroundColor = .white
        navigationItem.title = "Conversation"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reusebleUserCell)
        tableView.register(ChatCell.self, forCellReuseIdentifier: reusebleCellChat)
        tableView.separatorStyle = .none

        
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Input username for new chat"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(fetchChats), for: .valueChanged)
    }
    
    
    
    @objc func fetchChats(){
        refresh.beginRefreshing()
        listener?.remove()
        listener = MessageService.shared.getChats { (chats) in
            self.chats = chats
            self.refresh.endRefreshing()
        }
    }
    

    
}




//MARK: TableView Delegate and DataSource
extension ConversationController {
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch optionCell {
            case .message:
                return chats.count
            case .user:
                return userList.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch optionCell {
        case .message:
            let cell = tableView.dequeueReusableCell(withIdentifier: reusebleCellChat, for: indexPath) as! ChatCell
            cell.chat = chats[indexPath.row]
            return cell
        case .user:
            let cell = tableView.dequeueReusableCell(withIdentifier: reusebleUserCell, for: indexPath) as! UserCell
            cell.user = userList[indexPath.row]
            return cell
        }
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch optionCell {
        case .message:
            return 90
        case .user:
            return 50
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        switch optionCell {
        case .message:
            let controller = MessageController(chat: chats[indexPath.row])
            navigationController?.pushViewController(controller, animated: true)
            
        case .user:
            let controller = MessageController(newChatWithUser: userList[indexPath.row])
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    

    
}





//MARK: Delegate Search


extension ConversationController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        optionCell = .message
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            optionCell = .message
        }else{
            optionCell = .user
            let textForSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            UserService.shared.fetchUsers(query: textForSearch) { (users) in
                self.userList = users
            }
        }
        
    }
}

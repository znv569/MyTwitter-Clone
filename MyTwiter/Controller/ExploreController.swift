import UIKit



private let reuseIdentifier = "UserCell"



class ExploreController: UITableViewController {
    
    
    // MARK: - Properies
    var users: [User]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle

    init(){
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        configureUI()
        configureSearchController()
        configure()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }


    //MARK: - Helpers

    func configureUI(){
        
        
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        
    }
    
    
    func configure(query: String? = nil){
        
        UserService.shared.fetchUsers(query: query) { (users) in
            self.users = users
        }
    }
    
    
    func configureSearchController(){
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search user"
        searchController.searchBar.delegate = self
        
        definesPresentationContext = false
        
        navigationItem.searchController = searchController
        
    }
    
    
    
}



extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        cell.user = users![indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let user = users?[indexPath.row] else {return}
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
}



extension ExploreController: UISearchBarDelegate {

    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        let query = searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if query.isEmpty{
                  configure()
            }else{
                configure(query: query)
            }
        
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        configure()
    }
    
    
    
    
    
}


import UIKit

private let reusebleIdentifire = "cellActionSheet"

protocol ActionSheetLauncherDelegate: class {
    func didSelect(option: ActionSheetOption)
}


class ActionSheetLauncher: NSObject {
    
    
    //MARK: Properties
    let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    private lazy var viewModel = ActionSheetViewModel(user: user)
    
    weak var delegate: ActionSheetLauncherDelegate?
    
    var heigthSheet: CGFloat{
        return  ( 60 * CGFloat(viewModel.options.count) ) + 90
    }
    
    private lazy var blackScreen: UIView = {
       let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    //MARK: Lifecycle
    init(user: User){
        self.user = user
        super.init()
        
        configureTableView()
    }
    
    
    
    private lazy var cancelButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.layer.cornerRadius  = 50 / 2
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = .systemGroupedBackground
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var cancelContainerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, paddingRight: 12)
        return view
    }()
    
    
    
    
    
    
    //MARK: Helpers
    func show(){
        //guard let tab = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabController else { return }
       
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        self.window = window
        
        
        window.addSubview(blackScreen)
        blackScreen.frame = window.frame
        
        
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: heigthSheet)
        
        
        
        UIView.animate(withDuration: 0.3) {
            self.blackScreen.alpha = 1
            self.tableView.frame.origin.y -= self.heigthSheet
        }
        
    }
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.register(ACtionSheetCell.self, forCellReuseIdentifier: reusebleIdentifire)
    }
    
    
    func closeController(){
     
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame.origin.y += self.heigthSheet
            self.blackScreen.alpha = 0
        } completion: { _ in
            self.tableView.removeFromSuperview()
            self.blackScreen.removeFromSuperview()
        }

        
    }
    
    
    //MARK: Selectors
    
    @objc func handleDismissal(){
        closeController()
    }
    
    
}








extension ActionSheetLauncher: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusebleIdentifire, for: indexPath) as! ACtionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        delegate?.didSelect(option: option)
        closeController()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return cancelContainerView
    }
    
}

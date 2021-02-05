import UIKit
import Firebase

private let reusebleMessageCell = "MessageCell"

class MessageController: UIViewController{
    
    //MARK: Properties
    let chat: Chat
    
    private lazy var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10), style: .plain)
    
    var messages = [Message](){
        didSet(oldValue){
            tableView.reloadData()
            goToBottom(false)
            if oldValue.count != 0 {
                Utilites.shared.generator(generateType: .success)
            }
        }
    }
    
    

    var listener: ListenerRegistration?
    var timer: Timer?
    
    private lazy var footer = MessageInputView(width: view.frame.width)
    private var bottomConstraint: NSLayoutConstraint?
    
    //MARK: Lifecycle
    
    init(chat: Chat) {
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        MessageService.shared.readChat(chat: chat)
        configureNavi()
        configureKeyboard()
        configureUI()
    }
    
    convenience init(newChatWithUser user: User){
        let chat = Chat(fromUser: user, dictionary: [:])
        self.init(chat: chat)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("закрыт контроллер")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fetchMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Helpers
    
    
    func configureKeyboard(){
      
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.constant = -(kbFrameSize.height - 35)
            self.view.layoutIfNeeded()
        }
       
        
        DispatchQueue.main.async {

            self.goToBottom(true)

        }
        
    }
    
    @objc func kbDidHide() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func goToBottom(_ animated: Bool){
        let indexPath = IndexPath(row: messages.count-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    func configureNavi(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(handleBack))
        navigationItem.title = chat.fromUser.fullname
        
    }
    
    func configureUI(){
        hidesBottomBarWhenPushed = true
        
        hideKeyboardOnTap(#selector(self.dismissKeyboard), viewTap: tableView)
        
        footer.delegate = self
        view.addSubview(footer)
        footer.anchor(left: view.leftAnchor, right: view.rightAnchor)
        bottomConstraint = footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomConstraint?.isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: footer.topAnchor, right: view.rightAnchor)
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: reusebleMessageCell)
        view.backgroundColor = .rgb(red: 238, green: 238, blue: 238)
        tableView.separatorStyle = .none
       
        let fromRightToLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleBack))
        tableView.addGestureRecognizer(fromRightToLeft)
        
        
        
        timer?.invalidate()
        timer =  Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.reloadTime()
        }
        
        
    }
    

    
    
    func reloadTime(){
        for i in 0...messages.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? MessageCell
            cell?.reloadTime()
        }
    }
    
   func  fetchMessage(){
      listener?.remove()
      listener = MessageService.shared.getMessages(chat: chat) { messages in
            self.messages = messages
        }
    }
    
    
    
    //MARK: Selectors
    @objc func handleBack(){
        listener?.remove()
        timer?.invalidate()
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func handleLongPressMess(sender: UILongPressGestureRecognizer){
        if let cell = sender.view as? MessageCell {
            
            guard let indexPath = self.tableView.indexPath(for: cell) else {return}
            tableView.deleteRows(at: [indexPath], with: .left)
            
        }
    }
    
    
    
}



//MARK: TableView Delegate DataSource


extension MessageController: UITableViewDelegate, UITableViewDataSource  {
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusebleMessageCell, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressMess)) )
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = MessageViewModel(message: messages[indexPath.row])
        
        let width = ( view.frame.width * 0.8) - 76
        return viewModel.size(forWidth: width, forSizeFont: .systemFont(ofSize: 12)).height
    }
    
    

    
  
    
}


//MARK: Delegate Send Input
extension MessageController: MessageInputViewDelegate{
    
    func sendMessage(mess: String) {
        MessageService.shared.sendMessage(toUser: chat.fromUser, message: mess)
        goToBottom(true)
        view.endEditing(true)
    }
    
}



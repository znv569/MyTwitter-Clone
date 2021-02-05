import UIKit





class MessageCell: UITableViewCell {
    
    //MARK: Propertis
    
    var message: Message? {
        didSet{
            
            configure()
        }
    }
    
    
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "3м"
        label.textColor = .rgb(red: 108, green: 122, blue: 137)
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    
    private let messageLabel: UILabel = {
       let label = UILabel()
       label.text = "Тестовый текст для проверки"
       label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    
    
    
    private let containerView: UIView = {
       let vw = UIView()
        vw.backgroundColor = .rgb(red: 228, green: 241, blue: 254)
        vw.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        vw.layer.shadowRadius = 5
        vw.layer.shadowOpacity = 0.5
        vw.layer.shadowOffset = CGSize(width: 3, height: 3)

        vw.layer.cornerRadius = 8
        return vw
    }()
     
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstarint: NSLayoutConstraint?
    
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Helpers
    
    func configure(){
        guard let message = message else { return }

        if message.inbox {
            
            leftConstraint?.isActive = true
            rightConstarint?.isActive = false
            containerView.backgroundColor =  .rgb(red: 228, green: 241, blue: 254)
        }else{
            rightConstarint?.isActive = true
            leftConstraint?.isActive = false
            containerView.backgroundColor = .rgb(red: 135, green: 211, blue: 124)
        }
        
        containerView.isHidden = false
        messageLabel.text = message.message
        
        
        dateLabel.text = message.timestamp.dayExpire
        
        
        
    }
    
    func reloadTime(){
        guard let message = message else {   return }
        dateLabel.text = message.timestamp.dayExpire
    }
    
    
    
    
    func configureUI(){
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, paddingTop: 4, paddingBottom: 4, width: (frame.width * 0.8))
        
        leftConstraint = containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15)
        rightConstarint = containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15)
        
        containerView.addSubview(dateLabel)
        dateLabel.anchor(bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingBottom: 5, paddingRight: 10)
        
        containerView.addSubview(messageLabel)
        messageLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: dateLabel.bottomAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        

    }
    

    
    
}

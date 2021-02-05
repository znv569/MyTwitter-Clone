import UIKit



class ChatCell: UITableViewCell {
    
    //MARK: Properties
    var chat: Chat?{
        didSet{
            configure()
            
        }
    }
    
    private var time: String?{
        
        guard let chat = chat else { return nil }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: chat.timestamp, to: now) ?? "2m"
        
    }
    
    
    private let fromUserIV: UIImageView = {
       let iv = UIImageView()
        iv.layer.cornerRadius = 50 / 2
        iv.setDimensions(width: 50, height: 50)
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.twitterBlue.cgColor
        iv.layer.borderWidth = 0.2
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    
    private let underline: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.rgb(red: 218, green: 223, blue: 225)
        vw.heightAnchor.constraint(equalToConstant: 0.6).isActive = true
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    //MARK: Lificycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Helpers
    func configureUI(){
        let viewSelected = UIView()
        viewSelected.backgroundColor = .rgb(red: 238, green: 238, blue: 238)
        selectedBackgroundView = viewSelected
        
        let stack = UIStackView(arrangedSubviews: [fromUserIV, lastMessageLabel, timeLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 8
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
        
        addSubview(underline)
        underline.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 2, paddingBottom: 0, paddingRight: 2)
        
    }
    
    func configure(){
        
        guard let chat = chat else {return}
        fromUserIV.sd_setImage(with: chat.fromUser.profileImageUrl, completed: nil)
        lastMessageLabel.text = chat.lastMessage
        timeLabel.text  = time
        backgroundColor = chat.readed ? .white : UIColor.rgb(red: 197, green: 239, blue: 247)
        
    }
    
    //MARK: Selectors
    
    
    
}

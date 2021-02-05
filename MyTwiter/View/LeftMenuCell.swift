import UIKit


class LeftMenuCell: UITableViewCell {
  
    
    
    
    //MARK: Properties
    
    
    private var iconLabel: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .center

        
        
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    
    var option: LeftMenuOption?{
        didSet{
            configure()
        }
    }
    
    
    
    
    //MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: helpers
    func configureUI(){
        
        backgroundColor = .twitterBlue
        
        addSubview(iconLabel)
        iconLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, width: 20)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: iconLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 6, paddingBottom: 5, paddingRight: 12)
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.rgb(red: 20, green: 151, blue: 222)
       
        selectedBackgroundView = backgroundView
        
    }
    
    
    func configure(){
        guard let option = option else {return}
        nameLabel.text = option.description
        iconLabel.image = option.icon
    }
    

}

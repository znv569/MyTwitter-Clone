import UIKit



class ACtionSheetCell: UITableViewCell {
    
    //MARK: Properits
    
    var option: ActionSheetOption?{
        didSet{
            configure()
        }
    }
    
    
    private let optionalImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "twitter_logo_blue").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .twitterBlue
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "Test Option"
        return label
    }()
    
    
    
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Helpers
    func configureUI(){
        backgroundColor = .clear
        addSubview(optionalImageView)
        optionalImageView.centerY(inView: self)
        optionalImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        optionalImageView.translatesAutoresizingMaskIntoConstraints  = false
        optionalImageView.setDimensions(width: 36, height: 36)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionalImageView.rightAnchor, right: rightAnchor, paddingLeft: 20, paddingRight: 10)
    }
    
    
    func configure(){
        
        guard let option = option else { return }
        titleLabel.text = option.description
            
        switch option {
            case .delete:
                titleLabel.textColor = .systemRed
            default:
                titleLabel.textColor = .black
        }
        
    }
    
    
    
}

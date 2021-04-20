import UIKit

protocol  EditProfileCellDelegate: class{
    func updateValueText(option: EditProfileOption, value: String)
}

class EditProfileCell: UITableViewCell {
    
    
    //MARK: Properties
    
    weak var delegate: EditProfileCellDelegate?
    
    private let underlineView: UIView = {
       let vw = UIView()
        vw.backgroundColor = .lightGray
        vw.alpha = 0.2
        vw.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    
    var option: EditProfileOption?
    
    var viewModel: EditProfileViewModel?{
        didSet{
            configure()
        }
    }
    
 
    
    private lazy var inputText: UITextField =  {
        let tf = UITextField()
        tf.textColor = .twitterBlue
        tf.addTarget(self, action: #selector(inputChangeText), for: .editingChanged)
        
        return tf
    }()
    
    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 0
        textView.textColor = .black
        textView.delegate = self
        textView.backgroundColor = .white
        return textView
    }()
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        
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
        backgroundColor = .white
    
        
        
        
        contentView.addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        
        contentView.addSubview(labelName)
        labelName.anchor(top: topAnchor, left: leftAnchor, paddingTop: 14, paddingLeft: 6, width: 90, height: 20)
        
        
        contentView.addSubview(inputText)
        inputText.anchor(top: topAnchor, left: labelName.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 5)
        bringSubviewToFront(inputText)
        
        contentView.addSubview(inputTextView)
        inputTextView.anchor(top: topAnchor, left: labelName.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 5)
      
    }
    
    
    
    
    func configure(){
        guard let viewModel = viewModel else { return }
        
        inputText.isHidden = viewModel.showInputField
        inputTextView.isHidden = viewModel.showInputView
        
        inputText.text = viewModel.valueDefault
        inputTextView.text = viewModel.valueDefault
        
        labelName.text = viewModel.nameField
    }
    
    
    func focusInput(){
        
        if option != .bio {
            inputText.becomeFirstResponder()
        }else{
            inputTextView.becomeFirstResponder()
        }
        
    }
    
    
    
    //MARK: Selectors
    @objc func inputChangeText(){
        guard let delegate = delegate else { return }
        
        if option == .bio {
            delegate.updateValueText(option: option!, value: inputTextView.text)
        }else{
            delegate.updateValueText(option: option!, value: inputText.text!)
        }
    }
    
}



extension EditProfileCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        inputChangeText()
    }
    
}

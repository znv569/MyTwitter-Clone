import UIKit

protocol MessageInputViewDelegate: class {
    func sendMessage(mess: String)
}


class MessageInputView: UIView {
    
    
    //MARK: Properties
    private let inputViewText: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.textColor = .black
        tv.layer.cornerRadius = 5
        tv.layer.borderWidth = 0.4
        tv.layer.borderColor  = UIColor.rgb(red: 46, green: 49, blue: 49).cgColor
        tv.font = .systemFont(ofSize: 12)
        return tv
    }()
    weak var delegate: MessageInputViewDelegate?
    
    private var constraintForHeigth: NSLayoutConstraint?
    
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    private lazy var buttonSend: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .twitterBlue
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    
    init(width: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Helpers
    
    func configureUI(){
        
        autoresizingMask = .flexibleHeight
        
        constraintForHeigth = inputViewText.heightAnchor.constraint(equalToConstant: 40)
        constraintForHeigth?.isActive = true
        
        backgroundColor = .rgb(red: 191, green: 191, blue: 191)
        addSubview(buttonSend)
        buttonSend.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10, paddingRight: 5, width: 25  , height: 20)
        
        addSubview(inputViewText)
        inputViewText.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: buttonSend.leftAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
        inputViewText.delegate = self
        
        
        
    }
    
    
    //MARK: Selectors
    
    
    @objc func handleSendMessage(){
        delegate?.sendMessage(mess: inputViewText.text)
        inputViewText.text = ""
        textViewDidChange(inputViewText)
    }
    
    
}


extension MessageInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

        
        
        var contentSizeHeight = textView.sizeThatFits(textView.bounds.size).height + 10

        if contentSizeHeight > UIScreen.main.bounds.height / 5{
            textView.isScrollEnabled = true
            contentSizeHeight = (UIScreen.main.bounds.height / 5) + 10
        } else {
            textView.isScrollEnabled = false
        }
        
        
        constraintForHeigth?.constant = contentSizeHeight
        
    }

}

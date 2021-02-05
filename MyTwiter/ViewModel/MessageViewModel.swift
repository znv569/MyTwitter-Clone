import UIKit



class MessageViewModel {
    
    
    let message: Message
    

    
    init(message: Message){
        self.message = message
    }
    
    
    
    
    func size(forWidth width: CGFloat, forSizeFont font: UIFont) -> CGSize{
        let label = UILabel()
        label.font = font
        label.text = message.message
        //label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.numberOfLines = 0
        
        var height = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
       
        height.height += 50
        
        
        return height
    }
    
    
    
    
}

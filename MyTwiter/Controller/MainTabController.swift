//
//  MainTabController.swift
//  MyTwiter
//
//  Created by Admin on 05.11.2020.
//

import UIKit
import Firebase


class MainTabController: UITabBarController {
    
    
    // MARK: - Properies
    var user: User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
            
            guard let nav1 = viewControllers?[3] as? UINavigationController else { return }
            guard let conv = nav1.viewControllers.first as? ConversationController else { return }
            conv.user = user
        }
    }
    
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        authentificateUserAndConfigureUI()
       
    }
    
    
    
    
    //MARK:  - API
    
    func fetchUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserService.shared.fetchUser(uid: uid){ user in
            self.user = user
        }
    }
    
    func authentificateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            }
        }else{
            configureViewControl()
            configureUI()
            fetchUser()
        }
    }
    
    

    
    
    //MARK: - Selectors
    @objc func actionButtonTapped(button: UIButton){
        
        Utilites.shared.presentUpload(config: .tweet, target: self)
    }
    
    

    //MARK: - Helpers
    
    func configureUI(){
        
        
        
        tabBar.tintColor = .twitterBlue
        tabBar.unselectedItemTintColor = .white
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    

    func configureViewControl(){
        
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notification = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notification)
        
        let conversation = ConversationController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversation)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController{
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        
        
        nav.navigationBar.barTintColor = .lightGray

        nav.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
       
       
        
        return nav
    }
}




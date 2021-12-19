//
//  ClientLoginView.swift
//  SGS_SideProject
//
//  Created by 한상혁 on 2021/12/19.
//

import UIKit

class ClientLoginController: UIViewController {
    // MARK: - Properties
    
    var userEmail: String = ""
    
    private var userLabel: UILabel = {
        let lv = UILabel()
        lv.backgroundColor = .white
        lv.text = ""
        lv.setHeight(50)
        return lv
    }()
    
    private var loginLabel: UILabel = {
        let lv = UILabel()
        lv.backgroundColor = .white
        lv.text = "Login Success!"
        lv.setHeight(50)
        return lv
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helper
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(loginLabel)
        
        loginLabel.centerX(inView: view)
        loginLabel.centerY(inView: view)
        
        view.addSubview(userLabel)
        
        userLabel.centerX(inView: view)
        userLabel.anchor(bottom: loginLabel.topAnchor)
        userLabel.text = userEmail
    }
    
    // MARK: - FormViewModel
    
    
}



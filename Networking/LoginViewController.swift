//
//  LoginViewController.swift
//  Networking
//
//  Created by Max Pavlov on 18.02.22.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 400, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    

    private func setupViews() {
        view.addSubview(fbLoginButton)
    }
}

// MARK: - Facebook SDK
extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            guard let error = error else { return }
            print(error.localizedDescription)
        }
        
        guard AccessToken.isCurrentAccessTokenActive  else { return }
        
        openMainViewController()
        
        print("Successfully logget in with facebook")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        print("Did log out of facebook")
    }
    
    private func openMainViewController() {
        dismiss(animated: true)
    }
}

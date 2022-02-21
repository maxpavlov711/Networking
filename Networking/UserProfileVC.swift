//
//  UserProfileVC.swift
//  Networking
//
//  Created by Max Pavlov on 21.02.22.
//

import UIKit
import FBSDKLoginKit

class UserProfileVC: UIViewController {
    
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: view.frame.height - 170,
                                   width: view.frame.width - 64, height: 50)
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
extension UserProfileVC: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            guard let error = error else { return }
            print(error.localizedDescription)
        }
        
        print("Successfully logget in with facebook")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        print("Did log out of facebook")
        openLoginViewController()
    }
    
    private func openLoginViewController() {
        
        if !(AccessToken.isCurrentAccessTokenActive) {
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true, completion: nil)
                return
            }
        }
    }
    
    
}

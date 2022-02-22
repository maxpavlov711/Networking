//
//  LoginViewController.swift
//  Networking
//
//  Created by Max Pavlov on 18.02.22.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 350, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    lazy var customFacebookLoginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.backgroundColor = UIColor(hexValue: "#3B5999", alpha: 1)
        loginButton.setTitle("Login with Facebook", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.frame = CGRect(x: 32, y: 420, width: view.frame.width - 64, height: 50)
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector (handleCustomFacebookLogin), for: .touchUpInside)
        return loginButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    

    private func setupViews() {
        view.addSubview(fbLoginButton)
        view.addSubview(customFacebookLoginButton)
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
    
    @objc private func handleCustomFacebookLogin() {
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let result = result else { return }
            
            if result.isCancelled { return }
            else {
                self.singIntoFirebase()
                self.openMainViewController()
            }
        }
    }
    
    private func singIntoFirebase() {
        
        let accessToken = AccessToken.current
        
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { user, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("Successfully logget in with our FB user: ", user!)
        }
    }
}

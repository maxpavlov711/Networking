//
//  LoginViewController.swift
//  Networking
//
//  Created by Max Pavlov on 18.02.22.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController {
    
    var userProfile: UserProfile?
    
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
    
    lazy var googleLoginButton: GIDSignInButton = {
        let loginButton = GIDSignInButton()
        loginButton.frame = CGRect(x: 32, y: 490, width: view.frame.width - 64, height: 50)
        loginButton.addTarget(self, action: #selector(googleSingIn), for: .touchUpInside)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance.hasPreviousSignIn()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(fbLoginButton)
        view.addSubview(customFacebookLoginButton)
        view.addSubview(googleLoginButton)
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
        
        print("Successfully logget in with facebook")
        singIntoFirebase()
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
            
            print("Successfully logget in with our FB user")
            self.fetchFacebookFields()
        }
    }
    
    private func fetchFacebookFields() {
        
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start { _, result, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let userData = result as? [String: Any] {
                self.userProfile = UserProfile(data: userData)
                print(userData)
                print(self.userProfile?.name ?? "nil")
                self.saveIntoFirebase()
            }
        }
    }
    
    private func saveIntoFirebase() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userData = ["name": userProfile?.name, "email": userProfile?.email]
        
        let values = [uid: userData]
        
        Database.database().reference().child("users").updateChildValues(values) { error, _ in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("Successfully save user into firebase database")
            self.openMainViewController()
        }
    }
}

// MARK: - Google SDK
extension LoginViewController {
    
    @objc private func googleSingIn() {

        guard let clientId = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientId)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            print("Successfully logged into Google")

            Auth.auth().signIn(with: credential) { user, error in

                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                print("Successfully logged into Firebase wirh Google")
                self.openMainViewController()
            }
        }
    }
}

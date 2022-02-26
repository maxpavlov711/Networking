//
//  UserProfileVC.swift
//  Networking
//
//  Created by Max Pavlov on 21.02.22.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileVC: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: view.frame.height - 170,
                                   width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        userNameLabel.isHidden = true
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchingUserData()
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
        
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true, completion: nil)
                return
            }
        } catch let error {
            print("Failed to sign out with error: ", error.localizedDescription)
        }
    }
    
    private func fetchingUserData() {
        
        if Auth.auth() != nil {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
                
                guard let userData = snapshot.value as? [String: Any] else { return }
                
                let currentUser = CurrentUser(uid: uid, data: userData)
                guard let userName = currentUser?.name,
                      let userEmail = currentUser?.email else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.userNameLabel.isHidden = false
                self.userNameLabel.text = "\(userName)\n Logged in with Facebook\n\(userEmail)"
                
            } withCancel: { error in
                print(error.localizedDescription)
            }
        }
    }
}



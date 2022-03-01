//
//  SignUpViewController.swift
//  Networking
//
//  Created by Max Pavlov on 28.02.22.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView!
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        button.backgroundColor = .white
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(secondaryColor, for: .normal)
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(continueButton)
        setContinueButton(enable: false)
        
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.color = secondaryColor
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = continueButton.center
        view.addSubview(activityIndicator)
        
        userNameTextField.addTarget(self, action: #selector(textFiledChanget), for: .editingChanged)
        emailTextFeild.addTarget(self, action: #selector(textFiledChanget), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFiledChanget), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFiledChanget), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setContinueButton(enable: Bool) {
        if enable {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc private func keyboardWillAppear(notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        
        activityIndicator.center = continueButton.center
    }
    
    @objc private func textFiledChanget() {
        
        guard let userName = userNameTextField.text,
              let email = emailTextFeild.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return }
        
        let formFilled = !(userName.isEmpty) && !(email.isEmpty) && !(password.isEmpty) && confirmPassword == password
        
        setContinueButton(enable: formFilled)
    }
    
    @objc private func handleSignUp() {
        
        setContinueButton(enable: false)
        continueButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
    }
}

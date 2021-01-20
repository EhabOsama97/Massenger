//
//  LoginViewController.swift
//  Massenger
//
//  Created by Ehab Osama on 1/18/21.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
class LoginViewController: UIViewController {
    
    @IBOutlet weak var email_TextField: UITextField!
    @IBOutlet weak var password_TextField: UITextField!
    
    @IBOutlet weak var loginbutton: UIButton!
    //    private let FacebookLoginButton:FBLoginButton = {
    //        let button = FBLoginButton()
    //        button.permissions = ["email , public_profile"]
    //        return button
    //    }()
    let FacebookLoginButton :FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email,public_profile"]
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        FacebookLoginButton.center = view.center
        FacebookLoginButton.frame.origin.y = loginbutton.frame.maxY + 20
        FacebookLoginButton.frame = CGRect(x: loginbutton.frame.minX, y: loginbutton.frame.maxY+20, width: 344, height: 40)
        view.addSubview(FacebookLoginButton)
        FacebookLoginButton.delegate = self
        
        email_TextField.delegate = self
        password_TextField.delegate = self
        
        loginbutton.layer.cornerRadius = 15
        
        email_TextField.layer.cornerRadius = 15
        email_TextField.layer.borderWidth = 1
        email_TextField.layer.borderColor = UIColor.lightGray.cgColor
        
        password_TextField.layer.cornerRadius = 15
        password_TextField.layer.borderWidth = 1
        password_TextField.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @IBAction func login_pressed(_ sender: UIButton) {
        guard let email = email_TextField.text ,
              let pass = password_TextField.text ,
              pass.count>=8,
              !email.isEmpty,
              !pass.isEmpty
        else{
            alertUserLoginError()
            return
        }
        
        AuthManager.shared.loginUser(email: email, password: pass) { (succed) in
            if succed {
                DispatchQueue.main.async {
                    print("logged in ")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func Signup_pressed(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let RegistrationVC = storyBoard.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        //RegistrationVC.modalPresentationStyle = .fullScreen
        RegistrationVC.title = "Create Account"
        self.present(RegistrationVC, animated: true, completion: nil)
    }
    
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "",
                                      message: "Please enter all information to log in",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoginViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == email_TextField {
            password_TextField.becomeFirstResponder()
        }
        return true
    }
}

extension LoginViewController : LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(".... \(error)")
        }
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email,name"], tokenString: token, version: nil, httpMethod: .get)
        facebookRequest.start { (_, result, error) in
            guard let result = result as? [String : Any] , error == nil else {
                print("Failed to make facebook graph request")
                return
            }
            print("Resylt ....... \(result)")
            guard let username = result["name"] as? String,
                  let email = result["email"] as? String else {
                return
            }
            let nameComponents = username.components(separatedBy: " ")
            guard nameComponents.count == 2 else {
                return
            }
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            DatabaseManager.shared.validateNewUser(email: email) { (exists) in
                if !exists {
                    DatabaseManager.shared.insertUser(user: ChatAppUser(firstName: firstName, lastName: lastName, email: email))
                }
                
            }
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: {authResult , error in
            
            guard let result = authResult , error == nil else {
                print("Facebook credential login faild, MFA may be needed")
                return
            }
            print("Successufuly logged user in ")
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }
    
    
}


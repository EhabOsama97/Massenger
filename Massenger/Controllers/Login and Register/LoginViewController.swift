//
//  LoginViewController.swift
//  Massenger
//
//  Created by Ehab Osama on 1/18/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email_TextField: UITextField!
    @IBOutlet weak var password_TextField: UITextField!
    
    @IBOutlet weak var loginbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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


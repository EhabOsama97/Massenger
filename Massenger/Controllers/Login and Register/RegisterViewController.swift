//
//  RegisterViewController.swift
//  Massenger
//
//  Created by Ehab Osama on 1/18/21.
//

import UIKit
import SDWebImage

class RegisterViewController: UIViewController  {

    @IBOutlet weak var Profile_imageView: UIImageView!
    @IBOutlet weak var lastName_TextField: UITextField!
    @IBOutlet weak var firstName_TextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var email_TextField: UITextField!
    @IBOutlet weak var password_TextField: UITextField!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        email_TextField.delegate = self
        password_TextField.delegate = self
        firstName_TextField.delegate = self
        lastName_TextField.delegate = self
        imagePicker.delegate = self
        
        Profile_imageView.layer.borderWidth = 2
        Profile_imageView.layer.masksToBounds = false
        Profile_imageView.layer.cornerRadius = Profile_imageView.bounds.height / 2.0
        Profile_imageView.clipsToBounds = true
        Profile_imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        loginButton.layer.cornerRadius = 15
        
        email_TextField.layer.cornerRadius = 15
        email_TextField.layer.borderWidth = 1
        email_TextField.layer.borderColor = UIColor.lightGray.cgColor
        
        password_TextField.layer.cornerRadius = 15
        password_TextField.layer.borderWidth = 1
        password_TextField.layer.borderColor = UIColor.lightGray.cgColor
        
        firstName_TextField.layer.cornerRadius = 15
        firstName_TextField.layer.borderWidth = 1
        firstName_TextField.layer.borderColor = UIColor.lightGray.cgColor
        
        lastName_TextField.layer.cornerRadius = 15
        lastName_TextField.layer.borderWidth = 1
        lastName_TextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    @IBAction func login_pressed(_ sender: UIButton) {
        
        guard let email = email_TextField.text ,
              let pass = password_TextField.text ,
              let firstName = firstName_TextField.text,
              let lastName = lastName_TextField.text,
              pass.count >= 8,
              !email.isEmpty,
              !pass.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty
        else {
            alertUserLoginError(msg: "Please enter all information to create a new account.")
            return
        }
        
        //Sign Up
        DatabaseManager.shared.validateNewUser(email: email, completion: {exists in
            guard !exists else {
                //user aleardy exists
                self.alertUserLoginError(msg: "Email address already exists! Try another one.")
                return
            }
        })
        AuthManager.shared.registerNewUser( email: email, password: pass) { (registered) in
            DispatchQueue.main.async {
                if registered {
                    DatabaseManager.shared.insertUser(user: ChatAppUser(firstName: firstName, lastName: lastName, email: email) )
                    self.dismiss(animated: true, completion: nil)
                
                }
                else{
                    
                }
            }
        }
    }
    
    
    @IBAction func changePhoto_pressed(_ sender: UIButton) {
        didTapChangeProfilePicture()
    }
    

    
    func alertUserLoginError(msg :String) {
        let alert = UIAlertController(title: "",
                                      message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }

    

}

extension RegisterViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == firstName_TextField {
            lastName_TextField.becomeFirstResponder()
        }
        else if textField == lastName_TextField {
            email_TextField.becomeFirstResponder()
        }
        else if textField == email_TextField {
            password_TextField.becomeFirstResponder()
        }
        return true
    }
}

extension RegisterViewController:UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    private func didTapChangeProfilePicture () {
        
        
        let alertController = UIAlertController(title: "Profile Picture", message: "Choose Profile Picture", preferredStyle: .alert)
        let TakePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (UIAlertAction) in
            
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let ChooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        let CancleAction = UIAlertAction(title: "Cancle", style: .default) { (UIAlertAction) in
        }
        
        alertController.addAction(TakePhotoAction)
        alertController.addAction(ChooseFromLibraryAction)
        alertController.addAction(CancleAction)
        present(alertController, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.Profile_imageView.image = image
            }
        }

        dismiss(animated: true, completion: nil)
    }
    
}

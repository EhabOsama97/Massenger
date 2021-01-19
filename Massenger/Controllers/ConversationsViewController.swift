//
//  ViewController.swift
//  Massenger
//
//  Created by Ehab Osama on 1/18/21.
//

import UIKit
import FirebaseAuth
 

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CheckAuthStatus()
    }
    
    
    
    private func CheckAuthStatus() {
        // check Auth status
        print(Auth.auth().currentUser?.email)
//        do { try Auth.auth().signOut()
//            print("Sign Out Succeedded..............................")
//        } catch {
//            print("Sign Out failed..................................")
//        }
        if Auth.auth().currentUser == nil {
            //Show Sign in
            print("Dkhal fl iffff")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginVC = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            
            LoginVC.modalPresentationStyle = .fullScreen
            LoginVC.title = "Log In"
            DispatchQueue.main.async {
                self.present(LoginVC, animated: true, completion: nil)

            }
        }
        
        
        
    }
}


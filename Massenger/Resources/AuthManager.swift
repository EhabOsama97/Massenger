//
//  AuthManager.swift
//  Massenger
//
//  Created by Ehab Osama on 1/18/21.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    public func registerNewUser( email : String  , password :String, Completion: @escaping (Bool) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil , result != nil {
                print("new Account registered")
                let user = result?.user
                print("new use .. \(user)")
                Completion(true)
                //inset into DB
            }
            else{
                print("Error in register new account")
                Completion(false)
                return
                }
            
        }
        
    }
    
    
    public func loginUser ( email : String? ,password :String, complation: @escaping (Bool) -> Void) {
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else  {
                    complation(false)
                    return
                }
                complation(true)
                
            }
        }

    }
    
}

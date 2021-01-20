//
//  DatabaseManager.swift
//  Massenger
//
//  Created by Ehab Osama on 1/19/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://massenger-bf861-default-rtdb.firebaseio.com/").reference()
    
    
  
}
//MARK: - Account Management
extension DatabaseManager {
    
    public func validateNewUser (email:String , completion : @escaping ((Bool)-> Void)) {
        database.child(email.SafeDB()).observeSingleEvent(of: .value, with: {snapshot in
            guard let foundEmail = snapshot.value as? String else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func insertUser (user:ChatAppUser) {
        database.child(user.email.SafeDB()).setValue([
            "firstName" : user.firstName,
            "lastName" : user.lastName
        ])
    }
    
    
}

struct ChatAppUser {
    let firstName:String
    let lastName:String
    let email:String
    //let profilePictureUrl:String
}

extension String {
    func SafeDB () -> String{
        var s:String
        s = self.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        return s
    }
}


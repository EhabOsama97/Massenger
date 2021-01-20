//
//  ProfileViewController.swift
//  Massenger
//
//  Created by Ehab Osama on 1/18/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    let data = ["Log out"]
    @IBOutlet weak var TableVieww: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableVieww.delegate = self
        TableVieww.dataSource = self
        TableVieww.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

extension ProfileViewController:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableVieww.dequeueReusableCell(withIdentifier: "cell", for :indexPath) as! UITableViewCell
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       logOut()

        }
    
    
    
    
    func logOut (){
        let alertController = UIAlertController(title: "", message: "You want to log out ?", preferredStyle: .alert)
        
        let LogOutAction = UIAlertAction(title: "log out", style: .default) { (UIAlertAction) in
            
            AuthManager.shared.logOut()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginVC = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            
            LoginVC.modalPresentationStyle = .fullScreen
            LoginVC.title = "Log In"
            DispatchQueue.main.async {
                self.present(LoginVC, animated: true, completion: nil)

        }
        }
        
        

        let CancleAction = UIAlertAction(title: "Cancle", style: .default) { (UIAlertAction) in
        }
        
        alertController.addAction(LogOutAction)
        alertController.addAction(CancleAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
}

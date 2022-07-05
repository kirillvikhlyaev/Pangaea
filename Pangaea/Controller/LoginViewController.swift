//
//  LoginViewController.swift
//  Pangaea
//
//  Created by Кирилл on 05.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = C.AppInfo.appName
    }
    
    @IBAction func onLoginTap(_ sender: Any) {
        if let email = emailField.text, let pass = passField.text {
            Auth.auth().signIn(withEmail: email, password: pass) { (authDataResult, error) in
                if let e = error {
                    print("Ошибка входа: \(e.localizedDescription)")
                } else {
                    self.performSegue(withIdentifier: C.AppInfo.loginToChat, sender: self)
                }
            }
        }
    }

}

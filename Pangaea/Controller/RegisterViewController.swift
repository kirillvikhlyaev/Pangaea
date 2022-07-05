//
//  RegisterViewController.swift
//  Pangaea
//
//  Created by Кирилл on 05.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = C.AppInfo.appName
    }
    

    @IBAction func onRegisterTap(_ sender: UIButton) {
        if let email = emailField.text, let pass = passField.text {
            Auth.auth().createUser(withEmail: email, password: pass) { (authDataResult, error) in
                if let e = error {
                    print("Ошибка регистрации: \(e.localizedDescription)")
                } else {
                    self.performSegue(withIdentifier: C.AppInfo.registerToChat, sender: self)
                }
            }
        }
    }

}

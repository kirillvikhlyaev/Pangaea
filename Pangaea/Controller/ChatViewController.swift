//
//  ChatViewController.swift
//  Pangaea
//
//  Created by Кирилл on 05.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

class ChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    var messages : [Message] = []
    
    let db = Firestore.firestore() // База данных

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true // Убираем кнопку "Back"
        title = C.AppInfo.appName
        
        tableView.dataSource = self // Устанавливаем этот контроллер в качестве поставщика данных
        tableView.register(UINib(nibName: C.AppInfo.cellNibName, bundle: nil), forCellReuseIdentifier: C.AppInfo.cellIdetifier) // Регистрируем кастумную ячейку (сообщение)
        
        loadMessages()
    }
    
    func loadMessages() {
        // Сортируем коллекцию по времени отправки и добавляем слушатель
        db.collection(C.Firebase.collectionName).order(by: C.Firebase.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = [] // Очищаем массив сообщений
            if let e = error {
                print("Ошибка загрузки сообщений: \(e)")
            } else {
                if let snapshotDocs = querySnapshot?.documents {
                    for docs in snapshotDocs {
                        let data = docs.data()
                        if let messageBody = data[C.Firebase.messageBodyField] as? String, let sender = data[C.Firebase.senderField] as? String {
                            let newMessage = Message(body: messageBody, sender: sender)
                            self.messages.append(newMessage) // Добавляем сообщение в конец массива
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData() // Перезагружаем данные в таблице
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) // Прокручиваем до последнего сообщения
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true) // Возвращаем к главному экрану
        } catch let signOutError as NSError {
            print("Выйти не удалось: \(signOutError)")
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if let messageBody = messageField.text, let sender = Auth.auth().currentUser?.email {
            if messageField.text != "" {
                db.collection(C.Firebase.collectionName).addDocument(data: [
                    C.Firebase.messageBodyField : messageBody,
                    C.Firebase.senderField : sender,
                    C.Firebase.dateField : Date().timeIntervalSince1970 // Для сортировки добавляем время отправки
                ]) { (error) in
                    if let e = error {
                        print("Ошибка отправки: \(e)")
                    } else {
                        DispatchQueue.main.async { // Очищаем поле для ввода после отправки сообщения
                            self.messageField.text = ""
                        }
                    }
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.AppInfo.cellIdetifier, for: indexPath) as! CustomMessageCell // Объявляем ячейку как кастомное сообщение
        
        // Если сообщение другого пользователя, то даем другой стиль сообщениям
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftSenderImage.isHidden = true
            cell.rightSenderImage.isHidden = false
            cell.messageBody.backgroundColor = UIColor(named: C.AppInfo.secondaryColor)
            cell.label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            cell.leftSenderImage.isHidden = false
            cell.rightSenderImage.isHidden = true
            cell.messageBody.backgroundColor = UIColor(named: C.AppInfo.primaryColor)
            cell.label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        cell.label.text = message.body
        
        return cell
    }
    
    
}


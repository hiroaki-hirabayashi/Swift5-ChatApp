//
//  ChatViewController.swift
//  Swift5 ChatApp
//
//  Created by 平林宏淳 on 2020/05/28.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextFild: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    //スクリーンのサイズ
    let screenSize = UIScreen.main.bounds.size
    var chatArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "OriginCell")
        messageTextFild.delegate = self
        
        //ナビゲーションバーの戻るボタンを消す
        self.navigationItem.hidesBackButton = true

        
        //メッセージのセルを長さに合わせて可変にする
        tableView.rowHeight = UITableView.automaticDimension
        //初期の高さを決める
        tableView.estimatedRowHeight = 85
        
        //キーボードの設定(出す)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //キーボードの設定(隠す)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Firebaseからfetchしてくる(取得)
        fetchChatData()
        
        //セルのハイライト(行線)を消す
        tableView.separatorStyle = .none
        
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification){
        
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        
        messageTextFild.frame.origin.y = screenSize.height - keyboardHeight - messageTextFild.frame.height
        
        
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        
        messageTextFild.frame.origin.y = screenSize.height - messageTextFild.frame.height
        
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
        
        UIView.animate(withDuration: duration){
            
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
        
    }
    
    //キーボード以外をタップで閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        messageTextFild.resignFirstResponder()
    }
    //キーボードをエンターで閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //メッセージの数
        return chatArray.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OriginCell", for: indexPath) as! CustomCell
        cell.messageLabel.text = chatArray[indexPath.row].message
        cell.userNameLabel.text = chatArray[indexPath.row].sender
        cell.iconImageView.image = UIImage(named: "dogAvatarImage")
        
        if cell.userNameLabel.text == Auth.auth().currentUser?.email as! String {
            
            cell.messageLabel.backgroundColor = UIColor.flatGreen()
            //セルを角丸にする
            cell.messageLabel.layer.cornerRadius = 20
            cell.messageLabel.layer.masksToBounds = true
            
        }else{
            
            cell.messageLabel.backgroundColor = UIColor.flatBlue()
            //セルを角丸にする
            cell.messageLabel.layer.cornerRadius = 20
            cell.messageLabel.layer.masksToBounds = true
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
//        return view.frame.size.height/10
    }
    
    @IBAction func sendAction(_ sender: Any) {
        
        messageTextFild.endEditing(true)
        //isEnabled false無効化 true有効化
        messageTextFild.isEnabled = false
        sendButton.isEnabled = false
        
        //文字数制限
        if messageTextFild.text!.count > 15 {
            
            print("15文字以上です。")
            return
        }
        
        let chatDB = Database.database().reference().child("chats")
        
        //キーバリュー型で内容を送信(Dictionary型)
        let messageInfo = ["sender":Auth.auth().currentUser?.email, "message":messageTextFild.text!]
        
        //chatDBに入れる
        chatDB.childByAutoId().setValue(messageInfo) { (error, result) in
            
            if error != nil {
                
                print("error")
                
            }else{
                
                print("送信完了")
                self.messageTextFild.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextFild.text = ""
                
            }
        }
    }
    
    //データを引っ張ってくる。受信する
    func fetchChatData(){
        //どこからデータを引っ張ってくるか
        let fetchDataRef = Database.database().reference().child("chats")
        
        //新しく更新があった時に受信
        fetchDataRef.observe(.childAdded) { (snapShot) in
            
            let snapShotData = snapShot.value as! AnyObject
            let text = snapShotData.value(forKey: "message")
            let sender = snapShotData.value(forKey: "sender")

            let message = Message()
            message.message = text as! String
            message.sender = sender as! String
            self.chatArray.append(message)
            self.tableView.reloadData()
            
        }
        
    }
    

    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

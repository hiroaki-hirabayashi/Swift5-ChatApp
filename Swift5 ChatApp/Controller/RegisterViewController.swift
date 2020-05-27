//
//  RegisterViewController.swift
//  Swift5 ChatApp
//
//  Created by 平林宏淳 on 2020/05/27.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var emailTextFild: UITextField!
    @IBOutlet weak var passwordTextFild: UITextField!
    
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //Firebaseにユーザーを登録する(作成する)
    @IBAction func registerNewUser(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextFild.text!, password: passwordTextFild.text!) { (user, error) in
            
            if error != nil{
                
                print(error as Any)
                
            }else{
                
                print("ユーザーを登録しました。")
            }
        }
        
        func startAnimation(){
            
            let animation = Animation.named("loading")
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

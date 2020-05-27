//
//  LoginViewController.swift
//  Swift5 ChatApp
//
//  Created by 平林宏淳 on 2020/05/28.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextFild: UITextField!
    @IBOutlet weak var passwordTextFild: UITextField!
    
    let animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func login(_ sender: Any) {
        
        startAnimation()
        
        Auth.auth().signIn(withEmail: emailTextFild.text!, password: passwordTextFild.text!) { (user, error) in
            
            if error != nil{
                
                print("error")
            
            }else{
                
                print("ログインしました。")
                self.stopAnimation()
                self.performSegue(withIdentifier: "chat", sender: nil)
            }
            
        }
        
        
    }
    
    func startAnimation(){
        
        let animation = Animation.named("loading")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame
            .size.height)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        view.addSubview(animationView)
    }
    
    func stopAnimation(){
        
        animationView.removeFromSuperview()
        
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

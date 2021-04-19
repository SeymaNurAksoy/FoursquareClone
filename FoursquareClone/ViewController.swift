//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Şeyma Nur on 18.04.2021.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Parse Objesinde sınıf oluşturuyoruz
/*
        let parseObject  = PFObject(className: "Fruits")
        parseObject["name"] = "Muz"
        parseObject["colories"] = 123
        parseObject.saveInBackground{
            (success,error) in
            if(error != nil){
                
            }else{
                
            }

         }
  
        let query = PFQuery(className: "Fruits")
        //kosullu getirme
        query.whereKey("colories", greaterThan: 120)
      //  query.whereKey("name", contains: "Apple")
        query.findObjectsInBackground{(objets,error)
            in
            if(error != nil){
                
            }else{
                print(objets)
            }
        }*/
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != nil  && passwordText.text != nil {
        
            PFUser.logInWithUsername(inBackground: emailText.text!, password: passwordText.text!){
                (user,error) in
                if error != nil {
                    self.makeAler(titleInput: "Error", messageInput: error?.localizedDescription ?? "ERROR")
                }else{
                    print("basarılı")
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        
        }
        
        }
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != nil  && passwordText.text != nil {
            let user = PFUser();
            user.username = emailText.text!
            user.password = passwordText.text!
            user.signUpInBackground{
                (success,error) in
                if error != nil{
                    self.makeAler(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "ERROR")
                }else{
                    //Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
        }else{
            makeAler(titleInput: "ERROR", messageInput: "USERNAME / PASSWORD ??")
        }
    }
    func makeAler(titleInput:String,messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

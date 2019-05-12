
//  ViewController.swift
//  AgoraCard
//
//  Created by Alex Faltermeier on 26.03.19.
//  Copyright © 2019 Alex Faltermeier. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController, UITextViewDelegate {
    
    var ref: DatabaseReference!
    var user: String = ""
    var password: String = ""
    var wert: String = ""
    var email: String = "@agora.de"
    
    @IBOutlet weak var eingabePassword: UITextField!
    @IBOutlet weak var eingabeRFID: UITextField!
    @IBOutlet weak var buttonNFC: UIButton!
    @IBOutlet weak var buttonQR: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    
    
    @IBAction func rfidEingabe(_ sender: UITextField) {
        user = sender.text!
    }
    @IBAction func passwordEingabe(_ sender: UITextField) {
        password = sender.text!
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        //erweitere String
        let appendString = user+email
        //Sign in the user with Firebase
        Auth.auth().signIn(withEmail: appendString, password: password) { (user, error) in
            //Prüfen ob es einen User gibt
            if error != nil{
                return
            }
            //writing preferences
            let preferences = UserDefaults.standard
            preferences.set(self.user, forKey: "user")
            preferences.synchronize()
            
            //open next Screen
            let storyBoard = UIStoryboard(name: "Main", bundle:nil);
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UebersichtScene") ;
            self.present(nextViewController, animated:true, completion:nil);
        }
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        //erweitere String
        let appendString = user+email
        //Sign in the user with Firebase
        Auth.auth().createUser(withEmail: appendString, password: password) { (user, error) in
            //Prüfen ob es einen User gibt
            if user != nil{
                //writing preference
                
                let preferences = UserDefaults.standard
                preferences.set(self.user, forKey: "user")
                preferences.synchronize()
                
                //open next Screen
                let storyBoard = UIStoryboard(name: "Main", bundle:nil);
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginScene") ;
                self.present(nextViewController, animated:true, completion:nil);
            }
            else{
                //Fehler
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eingabeRFID.layer.cornerRadius = 20
        eingabePassword.layer.cornerRadius = 20
        buttonNFC.layer.cornerRadius = 20
        buttonQR.layer.cornerRadius = 20
        buttonLogin.layer.cornerRadius = 20
        buttonRegister.layer.cornerRadius = 20
        
    }
}


//
//  RegisterController.swift
//  AgoraCard
//
//  Created by Alex Faltermeier on 02.05.19.
//  Copyright © 2019 Alex Faltermeier. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterController: UIViewController {
    var user: String = ""
    var password: String = ""
    var wert: String = ""
    var email: String = "@agora.de"
    
    @IBOutlet weak var EingabeUser: UITextField!
    @IBOutlet weak var EingabePassword: UITextField!    
    @IBOutlet weak var ButtonRegister: UIButton!    
    @IBOutlet weak var QRButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    
    
    @IBAction func EingabeU(_ sender: UITextField) {
        user = sender.text!
    }
    
    @IBAction func EingabeP(_ sender: UITextField) {
        password = sender.text!
    }
    
    @IBAction func Register(_ sender: UIButton) {
        //erweitere String
        let appendString = user+email
        //Sign in the user with Firebase
        Auth.auth().createUser(withEmail: appendString, password: password) { (user, error) in
            //Prüfen ob es einen User gibt
            if user != nil{
                //writing preference
                
                let preferences = UserDefaults.standard
                preferences.set(self.user, forKey: "rfid")
                preferences.synchronize()
                
                //open next Screen
                let storyBoard = UIStoryboard(name: "Main", bundle:nil);
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UebersichtScene") ;
                self.present(nextViewController, animated:true, completion:nil);
            }
            else{
                //Fehler
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EingabePassword.layer.cornerRadius = 20
        EingabeUser.layer.cornerRadius = 20
        ButtonRegister.layer.cornerRadius = 20
        QRButton.layer.cornerRadius = 20
        BackButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }

}

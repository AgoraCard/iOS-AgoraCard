//
//  ViewUebersicht.swift
//  
//
//  Created by Alex Faltermeier on 29.03.19.
//

import UIKit
import FirebaseDatabase

class ViewUebersicht: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var Name: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var rfid: String = ""
    //Eine Referenz zur Firebase Database Kreieren
    var ref: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    //Für das Lesen von Daten. Empty String Array
    var postData = [String]()
    
    @IBOutlet weak var textRFID: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 20
        tableView.layer.cornerRadius = 20
        
        //Preferences
        let preferences = UserDefaults.standard
        rfid = (preferences.object(forKey: "rfid") as? String)!
        self.textRFID.text = rfid
        
        
        //Tabelle
        tableView.delegate = self
        tableView.dataSource = self
        //set the firebase reference
        ref = Database.database().reference()
        
        //Um alle Objekte aus Training zu bekommen
   //     let referenceToProductosPopulares = Database.database().reference(withPath: "RFID/"+rfid+"Training").observe(.value) { (DataSnapshot) in
  //      }
        

        databaseHandle = ref?.child("RFID").child(rfid).child("Training").observe(.childAdded, with:{ (DataSnapshot) in
            let post = DataSnapshot.value as? String
            if let actualPost = post{
                //Append the data to our postData array
                self.postData.append(actualPost)
                self.tableView.reloadData()
            }
        })
    }
    
    
    //Tabelle
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = postData[indexPath.row]
        return cell!
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        //Preferences
        let preferences = UserDefaults.standard
        preferences.set(self.rfid, forKey: "rfid")
        preferences.synchronize()
        //Go Back
        let storyBoard = UIStoryboard(name: "Main", bundle:nil);
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginScene") ;
        self.present(nextViewController, animated:true, completion:nil);
    }
}
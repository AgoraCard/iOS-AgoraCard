//
//  ViewUebersicht.swift
//  
//
//  Created by Alex Faltermeier on 29.03.19.
//

import UIKit
import FirebaseDatabase

class ViewUebersicht: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var Name: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var rfid: String = ""
    var ref: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    //Für das Lesen von Daten. Empty String Array
    var postData = [String]()
    
    let trainingData = ["Kurs", "Deutsch", "Mathe", "Datenbanken"]
    let dateDATA = ["Datum", "11.12.2019", "23.05.2020", "04.03.2021"]
    
    @IBOutlet weak var textRFID: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 20
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .clear
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        
        //Preferences
        let preferences = UserDefaults.standard
        rfid = (preferences.object(forKey: "user") as? String)!
        self.textRFID.text = rfid
        
        //Tabelle
        self.title = "UITableView"
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "tableViewCell")
        
        //set the firebase reference
        ref = Database.database().reference()
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.commonInit(trainingData[indexPath.item], date: dateDATA[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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

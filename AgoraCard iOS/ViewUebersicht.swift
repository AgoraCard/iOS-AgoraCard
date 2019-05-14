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
    
    var user: String = ""
    var ref: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    //Für das Lesen von Daten. Empty String Array
    var postData = [String]()
    
    var trainingData = ["Kurs"]
    var dateData = ["Datum"]
    
    @IBOutlet weak var textRFID: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 20
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .clear
        
        //Preferences
        let preferences = UserDefaults.standard
        user = (preferences.object(forKey: "user") as? String)!
        
        //Tabelle
        self.title = "UITableView"
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "tableViewCell")
        
        //set the firebase reference
        ref = Database.database().reference()
        
        ref?.child("USER").child(user).child("Person").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let vorname = value?["Vorname"] as? String ?? ""
            let nachname = value?["Nachname"] as? String ?? " "
            let geburtsdatum = value?["Geburtsdatum"] as? String ?? " "
            self.Name.text = vorname + " " + nachname
            self.textRFID.text = geburtsdatum
            
        }) { (error) in
            print(error.localizedDescription)
        }
 
        /*
       ref?.child("USER").child(user).child("Training").observe(.value, with:{ (DataSnapshot) in
            let post = DataSnapshot.value as? String
            self.ref?.child(post!).observe(.childAdded, with:{(DataSnapshot) in
                let valueData = DataSnapshot.value as? NSDictionary
                let training = valueData?.value(forKey: "Name")
                let daten = valueData?.value(forKey: "Date")
                self.trainingData.append(training as! String)
                self.dateDATA.append(daten as! String)
            })
        })
 */
        
        
        //let userID = Auth.auth().currentUser?.uid
        ref?.child("USER").child(user).child("Training").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let valueData = snapshot.value as? NSDictionary
            let keys = valueData?.allKeys
            for (value) in keys!{
                self.ref?.child("USER").child(self.user).child("Training").child(value as! String).observeSingleEvent(of: .value, with: { (shot) in
                    let valueData2 = shot.value as? NSDictionary
                   // for(suchen) in valueData2!{
                       // let training = suchen.key as? String ?? ""
                       // let date = suchen.value as? String ?? ""
                    
                        let training = valueData2?["Name"] as! String
                        let date = valueData2?["Date"] as! String
                
                        self.trainingData.append(training)
                        self.dateData.append(date)
               
                 //   }
                })
            }//END
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.trainingData.append("Englisch")
        self.dateData.append("11.11.11111")
    }
    

    
    //Tabelle
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.commonInit(trainingData[indexPath.item], date: dateData[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    @IBAction func buttonLogout(_ sender: Any) {
        //Preferences
        let preferences = UserDefaults.standard
        preferences.set(self.user, forKey: "user")
        preferences.synchronize()
        //Go Back
        let storyBoard = UIStoryboard(name: "Main", bundle:nil);
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginScene") ;
        self.present(nextViewController, animated:true, completion:nil);
    }
    
}

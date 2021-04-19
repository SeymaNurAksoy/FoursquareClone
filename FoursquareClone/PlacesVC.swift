//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Şeyma Nur on 18.04.2021.
//

import UIKit
import Parse

class PlacesVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId  = ""
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        getDataFromParse()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title :"Logout" ,style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground{
            [self](objects,error) in
            if error != nil {
                makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
            }else{
                if objects != nil {
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    if let placeName = object.object(forKey: "name") as? String{
                        if let placeId = object.objectId {
                            self.placeNameArray.append(placeName)
                            self.placeIdArray.append(placeId)
                        }
                    }
                }
                    self.tableView.reloadData()
            }
        }
    }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.choosenPlaceId = selectedPlaceId
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    @objc func addButtonClicked(){
        
        self.performSegue(withIdentifier: "toAddPlaceVC", sender:nil)
    }
    @objc func logoutButtonClicked(){
        
        PFUser.logOutInBackground(){
            (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error ", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
        
    }
    func makeAlert(titleInput:String,messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}

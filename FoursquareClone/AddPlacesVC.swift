//
//  AddPlacesVC.swift
//  FoursquareClone
//
//  Created by Şeyma Nur on 18.04.2021.
//

import UIKit

class AddPlacesVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var placeNameText: UITextField!
    
    @IBOutlet weak var placeTypeText: UITextField!
    
    @IBOutlet weak var placeDescriptionText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    

    @objc func chooseImage(){
        let picker = UIImagePickerController();
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func nextClicked(_ sender: Any) {
        if placeNameText.text != "" && placeTypeText.text != "" && placeDescriptionText.text != ""{
            if let choosenImageView = imageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeDescription  = placeDescriptionText.text!
                placeModel.placeImage = choosenImageView
                
            }else{
                let alert = UIAlertController(title: "Error" , message: "Place Name/Type/Description ?", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
       
        self.performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
}

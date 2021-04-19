//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Şeyma Nur on 18.04.2021.
//

import UIKit
import MapKit
import Parse
class MapVC: UIViewController ,MKMapViewDelegate , CLLocationManagerDelegate {
var locationManager = CLLocationManager()
   
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title :"Save" ,style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title :"Back" ,style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        //konum verilerinin doğruluğu
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //konum izinleri kullanma
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector (chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(recognizer)
        
        
    }
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
        
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches,toCoordinateFrom : self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.choosenLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.choosenLongititude = String(coordinates.longitude)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    @objc func saveButtonClicked(){
        //parse saved
        let placeModel = PlaceModel.sharedInstance
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["description"] = placeModel.placeDescription
        object["latitude"] = placeModel.choosenLatitude
        object["longititude"] = placeModel.choosenLongititude
        
        
        //gorsel kaydetmek --édata
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg",data: imageData)
        }
        object.saveInBackground{
            (success,error) in
            if error != nil {
                let alert = UIAlertController(title: "ERROR", message: error!.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
            
        }
    }
    
    @objc func backButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    


}

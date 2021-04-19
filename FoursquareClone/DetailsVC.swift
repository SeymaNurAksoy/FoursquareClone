//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Şeyma Nur on 18.04.2021.
//

import UIKit
import MapKit
import Parse
class DetailsVC: UIViewController ,MKMapViewDelegate {
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    @IBOutlet weak var mapkitView: MKMapView!
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var pimageView: UIImageView!
    var chosenLatitude = Double()
    var chosenLongitude = Double ()
    
    var choosenPlaceId =  ""
    override func viewDidLoad() {
        super.viewDidLoad()


       getDataParse()
        mapkitView.delegate = self
    
}
    
    func getDataParse(){
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", contains:choosenPlaceId)
        query.findObjectsInBackground{
            (objects,error) in
            if error != nil{
                
            }else{
                if objects != nil {
                    if objects!.count > 0{
                    let choosenPlaceObject = objects![0]
                        //objects
                        if let placeName =  choosenPlaceObject.object(forKey: "name" ) as? String{
                            self.placeNameLabel.text = placeName
                    }
                        
                        if let placeType =  choosenPlaceObject.object(forKey: "type" ) as? String{
                            self.placeTypeLabel.text = placeType
                    }
                        if let placeDescription =  choosenPlaceObject.object(forKey: "description" ) as? String{
                            self.placeDescriptionLabel.text = placeDescription
                    }
                        
                        if let placeLatitude =  choosenPlaceObject.object(forKey: "latitude" ) as? String{
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.chosenLatitude = placeLatitudeDouble
                            }
                    }
                        
                        
                        if let placeLongititude =  choosenPlaceObject.object(forKey: "longititude" ) as? String{
                            if let placeLongititudeDouble = Double(placeLongititude){
                                self.chosenLongitude = placeLongititudeDouble
                            }
                    }
                        if let imageData = choosenPlaceObject.object(forKey: "image") as? PFFileObject{
                            imageData.getDataInBackground{
                                (data,error) in
                                if error != nil{
                                }
                                    if data != nil{
                                    self.pimageView.image = UIImage(data : data!)
                                }
                                }
                        }
                    }
                    
                   //maps
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.mapkitView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title =   self.placeNameLabel.text!
                    annotation.subtitle = self.placeTypeLabel.text!
                    self.mapkitView.addAnnotation(annotation)
            }
        }
    }
    
    }
    //navigasyona götürcek butonu oluşturmak annation pin üstünde
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }
        else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0{
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count   > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
        
    }
}

//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Şeyma Nur on 18.04.2021.
//

import Foundation
import UIKit
class PlaceModel{
    
    static let sharedInstance = PlaceModel()
    var placeName = ""
    var placeType = ""
    var placeDescription =  ""
    var placeImage = UIImage()
    var choosenLatitude = ""
    var choosenLongititude = ""
    private init(){}
    
}

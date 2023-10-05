//
//  MapService.swift
//  PetApp
//
//  Created by Artur Imanbaev on 20.09.2023.
//

import Foundation
import MapKit
import CoreLocation

protocol MapServiceProtocol{
    func checkLocationIsEnabled() -> MapStep
    func getUserLocation(completion: @escaping((CLLocation) -> Void))
}

final class MapService: NSObject, MapServiceProtocol{
    
    private let manager = CLLocationManager()
    
    private var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping((CLLocation) -> Void)){
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    public func checkLocationIsEnabled() -> MapStep{
        if CLLocationManager.locationServicesEnabled(){
            return MapStep.alertIsRequired
        } else {
            return MapStep.mapIsRequired
        }
    }
}

extension MapService: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        completion?(location)
        manager.stopUpdatingLocation()
    }
}

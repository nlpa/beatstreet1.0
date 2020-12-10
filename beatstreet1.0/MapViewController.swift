//
//  MapViewController.swift
//  Beat Road 1.0
//
//  Created by Sal Abuali on 10/28/20.
//  Copyright © 2020 Sal Abuali, Jorge Angel, Natalie Lampa, Jonathan Eghan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
        // Connects mapKit
        @IBOutlet weak var mapView: MKMapView!
        
        var locationManager = CLLocationManager()
        let authorizationStatus = CLLocationManager.authorizationStatus()
        let regionRadius: Double = 1000
        var numberOfLongPress : Int = 0

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            mapView.delegate = self
            locationManager.delegate = self
            configureLocationServices()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    
    // This function represents the longPress for the app in order to drop a pin with and the address will be displayed
    @IBAction func longPressDetected(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
        var addressString = ""
        lookUpCurrentLocation(coordinate: newCoordinates) { (placemark) in
        let newPin = MKPointAnnotation()
        newPin.coordinate = newCoordinates
            if let placemark = placemark{
                addressString = "\(String(describing: placemark.subThoroughfare)) \(String(describing: placemark.subThoroughfare))"
                print(addressString)
                
                newPin.title = addressString
                self.mapView.addAnnotation(newPin)
            }
        }
    }

    // Gesture recognizer
    func action(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
    }
    
    // Centers the map around the current location of the user
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // a function that if the location isn't known, it'll ask to request your location
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }

    // reverse geoCodes in order to determine the address after the pindrop
    func lookUpCurrentLocation(coordinate: CLLocationCoordinate2D, completionHandler : @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
         let lastLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
    }
    
    // authorizes devices to access location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }
        centerMapOnUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnUserLocation()
    }
}
    
    

    

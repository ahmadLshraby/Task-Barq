//
//  ViewController.swift
//  Task
//
//  Created by Ahmad Shraby on 4/30/20.
//  Copyright © 2020 sHiKoOo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    var locationManager = CLLocationManager()   // instance
    var authorizationStatus = CLLocationManager.authorizationStatus() // to check authorization
    
    var newLat = 0.0
    var newLng = 0.0
    var newAdd = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
            navBarAppearance.backgroundColor = .black
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    @IBAction func currentLocationBtn(_ sender: RoundedButton) {
        configureLocationServices()
    }
    
    @IBAction func showVideosBtn(_ sender: RoundedButton) {
        performSegue(withIdentifier: "toVideosVC", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView" {
            let desVC = segue.destination as? MapViewVC
            desVC?.lat = newLat
            desVC?.lng = newLng
            desVC?.add = newAdd
        }
    }
    
    
}



// MARK: LOCATION MANAGER
extension ViewController: CLLocationManagerDelegate {
    
    // to check if app is authorized to use location
    func configureLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestLocation()
                locationManager.startUpdatingLocation()
                locationManager.startUpdatingHeading()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.startUpdatingLocation()
                if let coordinate = locationManager.location?.coordinate {
                    newLat = coordinate.latitude
                    newLng = coordinate.longitude
                    
                    performSegue(withIdentifier: "toMapView", sender: self)
                    locationManager.stopUpdatingLocation()
                }
            }
        } else {
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            //                print("Location services are not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            convertLatLongToAddress(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print("error:: \(error)")
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    
}


extension ViewController: MKMapViewDelegate {
    
    // Convert from location coordinate to real address
    func convertLatLongToAddress(latitude:Double,longitude:Double){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        var buildingName: String?
        var street: String?
        var city: String?
        var country: String?
        
        newAdd = ""
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            buildingName = placeMark?.name
            street = placeMark?.thoroughfare
            city = placeMark?.locality   // subAdministrativeArea
            country = placeMark?.isoCountryCode   // country
            
            if let bu = buildingName ,let st = street, let ci = city, let co = country {
                print("\(bu) \(st) \(ci) \(co)")
                self.newAdd = "\(bu) \(st) \(ci) \(co)"
            }else {
                self.newAdd = "Lat: \(latitude) & Lng: \(longitude)"
            }
        })
        
    }
    
}

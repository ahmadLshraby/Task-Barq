//
//  MapViewVC.swift
//  Task
//
//  Created by Ahmad Shraby on 4/30/20.
//  Copyright © 2020 sHiKoOo. All rights reserved.
//

import UIKit
import MapKit


class MapViewVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var lat = 0.0
    var lng = 0.0
    var add = "address" {
        didSet {
            title = add
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        mapView.setRegion(region, animated:true)
        convertLatLongToAddress(latitude: lat, longitude: lng)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Location info."
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
            navBarAppearance.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.1215686275, blue: 0.1411764706, alpha: 1)
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    @IBAction func infoBtn(_ sender: UIBarButtonItem) {
        shouldPresentAlertView(true, title: "Info", alertText: "Address: \(add)\nLat: \(lat)\nLng: \(lng)", actionTitle: "Ok", errorView: nil)
    }
    
    
    
}


extension MapViewVC: MKMapViewDelegate {
    
    // Called when the annotation was added
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.isDraggable = true
            pinView?.pinTintColor = #colorLiteral(red: 0.1490196078, green: 0.1725490196, blue: 0.3960784314, alpha: 1)
            
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView?.tintColor = #colorLiteral(red: 0.1490196078, green: 0.1725490196, blue: 0.3960784314, alpha: 1)
            pinView?.isEnabled = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            control.tintColor = #colorLiteral(red: 0.1490196078, green: 0.1725490196, blue: 0.3960784314, alpha: 1)
            shouldPresentAlertView(true, title: "Info", alertText: "Address: \(add)\nLat: \(lat)\nLng: \(lng)", actionTitle: "Ok", errorView: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending {
            if let droppedAt = view.annotation?.coordinate {
                
                convertLatLongToAddress(latitude: droppedAt.latitude, longitude: droppedAt.longitude)
            }
        }
    }
    
    // Convert from location coordinate to real address
    func convertLatLongToAddress(latitude:Double,longitude:Double){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        var buildingName: String?
        var street: String?
        var city: String?
        var country: String?
        
        add = ""
        
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
                self.add = "\(bu) \(st) \(ci) \(co)"
            }else {
                self.add = "Lat: \(latitude) & Lng: \(longitude)"
            }
        })
        
    }
    
}

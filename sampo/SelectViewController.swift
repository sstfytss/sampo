//
//  SelectViewController.swift
//  sampo
//
//  Created by Shun Sakai on 5/27/21.
//

import UIKit
import MapKit
import CoreLocation

class SelectViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()

//        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//        mapView.centerToLocation(initialLocation)
    }
    
    func setupLocation(){
        
    }

}

//private extension MKMapView {
//    
//    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
//        let coordinateRegion = MKCoordinateRegion(
//            center: location.coordinate,
//            latitudinalMeters: regionRadius,
//            longitudinalMeters: regionRadius)
//          setRegion(coordinateRegion, animated: true)
//    }
//}

extension SelectViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //1
      if locations.count > 0 {
        let location = locations.last!
        print("Accuracy: \(location.horizontalAccuracy)")
        
        //2
        if location.horizontalAccuracy < 100 {
          //3
          manager.stopUpdatingLocation()
          let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
          let region = MKCoordinateRegion(center: location.coordinate, span: span)
          mapView.region = region
          // More code later...
        }
      }
    }

}

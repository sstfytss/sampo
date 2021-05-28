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
    fileprivate var startedLoadingPOIs = false
    fileprivate var placesArray = [Place]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        placesArray = [Place(x: 35.6607081, y: 139.6651037), Place(x: 35.6605384, y: 139.6646573)]

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
            print("Accuracy: \(location.horizontalAccuracy), location: \(location)")
            
            if location.horizontalAccuracy < 100 {
                //3
                manager.stopUpdatingLocation()
                let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.region = region
                
                if !startedLoadingPOIs {
                    startedLoadingPOIs = true
                    //1
                    for place in placesArray {
                        //3
                        guard let latitude = place.x else { return }
                        guard let longitude = place.y else { return }

                        let annotation = Annotation(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: "place.placeName")
                        DispatchQueue.main.async {
                            self.mapView.addAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
    
}

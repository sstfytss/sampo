//
//  SelectViewController.swift
//  sampo
//
//  Created by Shun Sakai on 5/27/21.
//

import UIKit
import MapKit
import CoreLocation
import HDAugmentedReality

class SelectViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var startedLoadingPOIs = false
    fileprivate var placesArray = [Place]()
    fileprivate var annotationArray = [Annotation]()
    fileprivate var arViewController: ARViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        placesArray = [Place(x: 35.6607081, y: 139.6651037), Place(x: 35.6605384, y: 139.6646573)]
    }
    
    func setupLocation(){
        
    }
    
//    @IBAction func showARController(_ sender: Any){
//        arViewController = ARViewController()
//        //1
//        arViewController.dataSource = self
//        //2
////        arViewController.maxVisibleAnnotations = 30
////        arViewController.headingSmoothingFactor = 0.05
////        //3
////        arViewController.setAnnotations(annotationArray)
//            
//        self.present(arViewController, animated: true, completion: nil)
//    }

}

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
                        annotationArray.append(annotation)
                        DispatchQueue.main.async {
                            self.mapView.addAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
    
}

//extension SelectViewController: ARDataSource {
//
//  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
//    let annotationView = AnnotationView()
//    annotationView.annotation = viewForAnnotation
//    annotationView.delegate = self
//    annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
//    
//    return annotationView
//  }
//}
//
//extension SelectViewController: AnnotationViewDelegate {
//  func didTouch(annotationView: AnnotationView) {
//    print("Tapped view for POI: \(annotationView.titleLabel?.text)")
//  }
//}

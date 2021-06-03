//
//  TrackingViewController.swift
//  sampo
//
//  Created by Shun Sakai on 6/2/21.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class TrackingViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var currentUser: User = Auth.auth().currentUser!
    
    fileprivate let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var path: [CLLocationCoordinate2D] = []
    let defaults = UserDefaults.standard
    var initial = true

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        mapView.delegate = self
        locationManager.delegate = self
        saveButton.isHidden = true
        topView.isHidden = true
        completeLabel.isHidden = true
        setupLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.path.removeAll()
    }
    
    @IBAction func done(){
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
        let polyline = MKPolyline(coordinates: self.path, count: self.path.count)
        setVisibleMapArea(polyline: polyline, edgeInsets: UIEdgeInsets(top: 60.0, left: 40.0, bottom: 40.0, right: 40.0), animated: true)
        doneButton.isHidden = true
        saveButton.isHidden = false
        topView.isHidden = false
        completeLabel.isHidden = false
    }
    
    @IBAction func save(){
        let alert = UIAlertController(title: "Saved", message: "Your Sampo Route Has Been Saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let root = self.ref?.child("Routes")
            let p2 = self.ref?.child("Users")
            let identifier = UUID().uuidString
            let x = self.splitCoordsX()
            let y = self.splitCoordsY()
            root?.child(identifier).child("pathX").setValue(x)
            root?.child(identifier).child("pathY").setValue(y)
            root?.child(identifier).child("userid").setValue(self.currentUser.uid)
            p2?.child(self.currentUser.uid).child("routes").child(identifier).child("name").setValue("name")
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func splitCoordsX() -> [String]{
        let pathArray = self.path
        var xArray: [String] = []
        for i in 0 ..< pathArray.count {
            let x = pathArray[i].latitude
            xArray.append(String(x))
        }
        return xArray
    }
    
    func splitCoordsY() -> [String]{
        let pathArray = self.path
        var yArray: [String] = []
        for i in 0 ..< pathArray.count {
            let y = pathArray[i].longitude
            yArray.append(String(y))
        }
        return yArray
    }
    
    func setupLocation(){
        mapView.showsUserLocation = true
        locationManager.distanceFilter = 20
        locationManager.headingFilter = 30
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //1
        if locations.count > 0 {
            let location = locations.last!
            currentLocation = location
            print("Accuracy: \(location.horizontalAccuracy), location: \(locations)")
            
            if self.initial == true {
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                let annotation = Annotation(location: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), title: "Start")
                self.initial = false
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)
                    self.mapView.region = region
                }
  
            }

            //add updated location to coordinate array
            path.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            print("pathArray: \(path)")
            updatePath()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if currentLocation != nil{
            self.path.append(CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
            updatePath()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polyLineRender = MKPolylineRenderer(overlay: overlay)
            polyLineRender.strokeColor = UIColor.blue.withAlphaComponent(1)
            polyLineRender.lineWidth = 3

            return polyLineRender
        }
        return MKPolylineRenderer()
    }
    
    func updatePath(){
        if self.path.count > 1{
            if self.path.count == 2{
                let pathWalked = MKPolyline(coordinates: self.path, count: self.path.count)
                self.mapView.addOverlay(pathWalked)
            }else{
                if let overlays = mapView?.overlays {
                    for overlay in overlays {
                        // remove all MKPolyline-Overlays
                        if overlay is MKPolyline {
                            mapView?.removeOverlay(overlay)
                        }
                    }
                }
                let newPath = MKPolyline(coordinates: self.path, count: self.path.count)
                self.mapView.addOverlay(newPath)
            }
        }
    }
    
    func setVisibleMapArea(polyline: MKPolyline, edgeInsets: UIEdgeInsets, animated: Bool = false) {
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgeInsets, animated: animated)
    }

}

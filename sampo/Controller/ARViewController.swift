//
//  ARViewController.swift
//  sampo
//
//  Created by Shun Sakai on 5/30/21.
//

import UIKit
import ARCL
import CoreLocation
import MapKit

class ARViewController: UIViewController {
    var sceneLocationView = SceneLocationView()
    var coordinates: [CLLocationCoordinate2D] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        coordinates.append(CLLocationCoordinate2D(latitude: 35.65986915, longitude: 139.6638398))
        coordinates.append(CLLocationCoordinate2D(latitude: 35.6600031, longitude: 139.6642768))
        coordinates.append(CLLocationCoordinate2D(latitude: 35.6601289, longitude: 139.6646483))
        let p = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
        let polyline = PolylineNode(polyline: p, altitude: 50)
        let coordinate = CLLocationCoordinate2D(latitude: 35.65999063, longitude: 139.66427402)
        let coordinate2 = CLLocationCoordinate2D(latitude: 35.65199745, longitude: 140.05476916)
        
        let location = CLLocation(coordinate: coordinate2, altitude: 0)
        let location2 = CLLocation(coordinate: coordinate2, altitude: 300)
        let image = UIImage(named: "pin2")!
        let image2 = UIImage(named: "pin2")!

        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: polyline)
//        sceneLocationView.addPolylines(polylines: [p]) { SCNBox in
//            let box = SCNBox(width: 1.75, height: 0.5, length: 20.0, chamferRadius: 0.25)
//              box.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.7)
//              return box
//        }
       // let annotationNode2 = LocationAnnotationNode(location: location2, image: image2)
        //sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode2)

        
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }

}

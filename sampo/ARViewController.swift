//
//  ARViewController.swift
//  sampo
//
//  Created by Shun Sakai on 5/30/21.
//

import UIKit
import ARCL
import CoreLocation

class ARViewController: UIViewController {
    var sceneLocationView = SceneLocationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        let coordinate = CLLocationCoordinate2D(latitude: 35.65999063, longitude: 139.66427402)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        let image = UIImage(named: "pin")!

        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }

}

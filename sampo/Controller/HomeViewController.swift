//
//  HomeViewController.swift
//  sampo
//
//  Created by Shun Sakai on 5/23/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet var myRoutes: UICollectionView!
    
    var routes: [String] = []
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var currentUser: User = Auth.auth().currentUser!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.myRoutes.delegate = self
        self.myRoutes.dataSource = self
        self.myRoutes.reloadData()
    }
    
    func refresh(){
        self.routes = []
        loadData {
            self.myRoutes.delegate = self
            self.myRoutes.dataSource = self
            self.myRoutes.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("routes: \(routes.count)")
        return routes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myRoutes.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyRouteCell
        
        cell.number.text = String(routes[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let routeID = routes[indexPath.row]
        defaults.setValue(routeID, forKey: "routeSelected")
        self.performSegue(withIdentifier: "showRoute", sender: self)
    }
    
    func loadData(completion: @escaping () -> ()){
        let path = self.ref.child("Users").child(self.currentUser.uid).child("routes")

        path.observeSingleEvent(of: .value) { (r) in
            for child in r.children.allObjects as! [DataSnapshot] {
                let c = child.key
                self.routes.append(c)
                
            }
            print("child received: \(self.routes)")
            completion()
        }
    }
}

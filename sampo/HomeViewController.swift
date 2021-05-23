//
//  HomeViewController.swift
//  sampo
//
//  Created by Shun Sakai on 5/23/21.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet var myRoutes: UICollectionView!
    
    var routes: [Int] = [1, 2, 3, 4, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myRoutes.delegate = self
        myRoutes.dataSource = self
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myRoutes.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyRouteCell
        
        cell.number.text = String(routes[indexPath.row])
        
        return cell
    }
    
    
}

//
//  LocationDetailViewController.swift
//  Virtual Tourist
//
//  Created by Julia Will on 28.11.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class LocationDetailViewController: UIViewController {

    var pin:Pin!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addAnnotation(pin)
        mapView.setCenterCoordinate(pin.coordinate, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: handle New Collection Touch
    // TODO: load images

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

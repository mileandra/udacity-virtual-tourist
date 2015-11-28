//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Julia Will on 28.11.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//
//  TODO: The center of the map and the zoom level should be persistent. If the app is turned off, the map should return to the same state when it is turned on again.
//  TODO: When a pin is tapped, the app will navigate to the Photo Album view associated with the pin.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a LongPressGestureRecognizer to add a new Pin
        let longPress = UILongPressGestureRecognizer(target: self, action: "addPin:")
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Adding Pins
    func addPin(gestureRecognizer: UIGestureRecognizer) {
        let locationInMap = gestureRecognizer.locationInView(mapView)
        let coord:CLLocationCoordinate2D = mapView.convertPoint(locationInMap, toCoordinateFromView: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = "New Location"
        annotation.subtitle = "New Subtitle"
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Pin selected")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

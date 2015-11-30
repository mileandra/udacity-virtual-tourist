//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Julia Will on 28.11.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//
//  TODO: When a pin is tapped, the app will navigate to the Photo Album view associated with the pin.
//  TODO: pass pin object to detail view controller
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPin:Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a LongPressGestureRecognizer to add a new Pin
        let longPress = UILongPressGestureRecognizer(target: self, action: "addPin:")
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
        
        loadMapRegion()
        mapView.addAnnotations(fetchAllPins())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Core Data implementation
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func fetchAllPins() -> [Pin] {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        var pins:[Pin] = []
        do {
            let results = try sharedContext.executeFetchRequest(fetchRequest)
            pins = results as! [Pin]
        } catch let error as NSError {
            //TODO: handle error better
            print("An error occured accessing managed object context \(error.localizedDescription)")
        }
        return pins
    }
    

    // MARK: - Adding Pins
    func addPin(gestureRecognizer: UIGestureRecognizer) {
        let locationInMap = gestureRecognizer.locationInView(mapView)
        let coord:CLLocationCoordinate2D = mapView.convertPoint(locationInMap, toCoordinateFromView: mapView)
        
        let pin = Pin(coordinate: coord, context: sharedContext)
        mapView.addAnnotation(pin)
        
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    
    // MARK - MKMapViewDelegate methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Pin {
            let identifier = "Pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
                view.animatesDrop = true
                view.draggable = false
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Pin selected")
        let annotation = view.annotation as! Pin
        selectedPin = annotation
        performSegueWithIdentifier("locationDetail", sender: self)
    }
    
    // We need to detect any changes in region to store them
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Saving Map Coordinates")
        saveMapRegion()
    }
    
    
    // MARK - save and load map region
    struct mapKeys {
        static let centerLatitude = "CenterLatitudeKey"
        static let centerLongitude = "CenterLongitude"
        static let spanLatitude = "SpanLatitudeDeltaKey"
        static let spanLongitude = "SpanLongitudeDeltaKey"
    }
    
    
    func saveMapRegion() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setDouble(mapView.region.center.latitude, forKey: mapKeys.centerLatitude)
        userDefaults.setDouble(mapView.region.center.longitude, forKey: mapKeys.centerLongitude)
        userDefaults.setDouble(mapView.region.span.latitudeDelta, forKey: mapKeys.spanLatitude)
        userDefaults.setDouble(mapView.region.span.longitudeDelta, forKey: mapKeys.spanLongitude)
    }
    
    func loadMapRegion() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let centerLatitude = userDefaults.doubleForKey(mapKeys.centerLatitude)
        
        if centerLatitude != 0 {
            let centerLongitude = userDefaults.doubleForKey(mapKeys.centerLongitude)
            let spanLatitude = userDefaults.doubleForKey(mapKeys.spanLatitude)
            let spanLongitude = userDefaults.doubleForKey(mapKeys.spanLongitude)
            
            let center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude)
            let span = MKCoordinateSpanMake(spanLatitude, spanLongitude)
            let region = MKCoordinateRegionMake(center, span)
            mapView.region = region
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "locationDetail" {
            let controller = segue.destinationViewController as! LocationDetailViewController
            controller.pin = selectedPin
        }
    }
    

}

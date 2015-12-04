//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Julia Will on 28.11.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//
// TODO: preload images
// TODO: better error handling
// TODO: save Map Region through Core Data

import UIKit
import MapKit
import CoreData

class MapViewController: BaseViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var selectedPin:Pin!
    var lastAddedPin:Pin? = nil
    var isEditMode = false
    
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
    
    func fetchAllPins() -> [Pin] {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        var pins:[Pin] = []
        do {
            let results = try sharedContext.executeFetchRequest(fetchRequest)
            pins = results as! [Pin]
        } catch let error as NSError {
            showAlert("Ooops", message: "Something went wrong when trying to load existing data")
            print("An error occured accessing managed object context \(error.localizedDescription)")
        }
        return pins
    }
    

    // MARK: - Adding and removing Pins
    func addPin(gestureRecognizer: UIGestureRecognizer) {
        
        if isEditMode {
            return
        }
 
        let locationInMap = gestureRecognizer.locationInView(mapView)
        let coord:CLLocationCoordinate2D = mapView.convertPoint(locationInMap, toCoordinateFromView: mapView)
        
        switch gestureRecognizer.state {
            case UIGestureRecognizerState.Began:
                lastAddedPin = Pin(coordinate: coord, context: sharedContext)
                mapView.addAnnotation(lastAddedPin!)
            case UIGestureRecognizerState.Changed:
                lastAddedPin!.willChangeValueForKey("coordinate")
                lastAddedPin!.coordinate = coord
                lastAddedPin!.didChangeValueForKey("coordinate")
            case UIGestureRecognizerState.Ended:
                getPhotosForPin(lastAddedPin!) { (success, errorString) in
                    self.lastAddedPin!.isDownloading = false
                    if success == false {
                        self.showAlert("An error occurred", message: errorString!)
                        return
                    }
                }
                CoreDataStackManager.sharedInstance().saveContext()
            default:
                return
        }
        
    }
    func deletePin(pin: Pin) {
        mapView.removeAnnotation(pin)
        sharedContext.deleteObject(pin)
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    
    @IBAction func toggleEditMode(sender: AnyObject) {
        if isEditMode {
            isEditMode = false
            editButton.title = "Edit"
        } else {
            isEditMode = true
            editButton.title = "Done"
        }
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
        if !isEditMode {
            performSegueWithIdentifier("locationDetail", sender: self)
        } else {
            let alert = UIAlertController(title: "Delete Pin", message: "Do you want to remove this pin?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))

            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                self.selectedPin = nil
                self.deletePin(annotation)
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
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

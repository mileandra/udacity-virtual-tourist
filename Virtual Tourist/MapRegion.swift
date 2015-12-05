
//
//  MapRegion.swift
//  Virtual Tourist
//
//  Created by Julia Will on 04.12.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//

import CoreData
import MapKit

class MapRegion: NSManagedObject {
 
    @NSManaged var centerLatitude: Double
    @NSManaged var centerLongitude: Double
    @NSManaged var spanLatitude: Double
    @NSManaged var spanLongitude: Double
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(region: MKCoordinateRegion, context: NSManagedObjectContext) {
        
        //Core Data
        let entity = NSEntityDescription.entityForName("MapRegion", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.region = region
    }
    
    var region: MKCoordinateRegion {
        set {
            centerLatitude = newValue.center.latitude
            centerLongitude = newValue.center.longitude
            spanLatitude = newValue.span.latitudeDelta
            spanLongitude = newValue.span.longitudeDelta
        }
        get {
            let center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude)
            let span = MKCoordinateSpanMake(spanLatitude, spanLongitude)
            return MKCoordinateRegionMake(center, span)
        }
    }
}

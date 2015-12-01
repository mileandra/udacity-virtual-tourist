//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Julia Will on 30.11.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//

import CoreData

class Photo: NSManagedObject {

    @NSManaged var photoURL: String
    @NSManaged var imagePath: String?
    @NSManaged var pin: Pin
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(photoURL: String, pin: Pin, context: NSManagedObjectContext) {
        
        //Core Data
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.photoURL = photoURL
        self.pin = pin
    }
}

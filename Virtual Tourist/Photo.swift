//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Julia Will on 30.11.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//

import UIKit
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
    
    var image: UIImage? {
        if imagePath != nil {
            let fileURL = getFileURL()
            return UIImage(contentsOfFile: fileURL.path!)
        }
        return nil
    }
    
    func getFileURL() -> NSURL {
        let fileName = (imagePath! as NSString).lastPathComponent
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let pathArray:[String] = [dirPath, fileName]
        let fileURL = NSURL.fileURLWithPathComponents(pathArray)
        return fileURL!
    }
    
    // Make sure the current image is deleted from teh file system when a Photo is deleted
    override func prepareForDeletion() {
        let fileURL = getFileURL()
        if NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(fileURL.path!)
            } catch let error as NSError {
                print(error.userInfo) // fail silent
            }
        }        
    }
}

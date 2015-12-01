//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Julia Will on 30.11.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    var session: NSURLSession
 // TODO: implement image search
    
    private override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: GET Methods
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
    }
}

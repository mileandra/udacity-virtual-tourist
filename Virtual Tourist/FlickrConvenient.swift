//
//  FlickrConvenient.swift
//  Virtual Tourist
//
//  Created by Julia Will on 01.12.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//

import Foundation
import CoreData

extension FlickrClient {
    

    func getPhotosForPin(pin: Pin, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let parameters = [
            ParameterKeys.METHOD: Methods.SEARCH,
            ParameterKeys.EXTRAS: ParameterValues.URL_M,
            ParameterKeys.FORMAT: ParameterValues.JSON_FORMAT,
            ParameterKeys.NO_JSON_CALLBACK: "1",
            ParameterKeys.SAFE_SEARCH: "1",
            ParameterKeys.BBOX: createBoundingBoxString(pin)
        ]
        
        taskForGETMethod(parameters) { (JSONResult, error) in
            if let error = error {
                var errorMessage = ""
                switch error.code {
                case 2:
                    errorMessage = "Network connection lost"
                    break
                default:
                    errorMessage = "A technical error occured while fetching photos"
                    break
                }
                completionHandler(success: false, errorString: errorMessage)
            } else {
                print(JSONResult)
            }
        }
    }
    
    func createBoundingBoxString(pin: Pin) -> String {
        
        let latitude = pin.coordinate.latitude
        let longitude = pin.coordinate.longitude
        
        /* Fix added to ensure box is bounded by minimum and maximums */
        let bottom_left_lon = max(longitude - BBoxParameters.BOUNDING_BOX_HALF_WIDTH, BBoxParameters.LON_MIN)
        let bottom_left_lat = max(latitude - BBoxParameters.BOUNDING_BOX_HALF_HEIGHT, BBoxParameters.LAT_MIN)
        let top_right_lon = min(longitude + BBoxParameters.BOUNDING_BOX_HALF_HEIGHT, BBoxParameters.LON_MAX)
        let top_right_lat = min(latitude + BBoxParameters.BOUNDING_BOX_HALF_HEIGHT, BBoxParameters.LAT_MAX)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
}

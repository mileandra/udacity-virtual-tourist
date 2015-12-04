//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Julia Will on 30.11.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//

import Foundation

extension FlickrClient {

    struct Constants {
        static let APIKey   = "e86a1f8a8d13068a4341545a51bea638"
        static let BASE_URL = "https://api.flickr.com/services/rest/"
    }
    
    struct Methods {
        static let SEARCH = "flickr.photos.search"
    }
    
    struct ParameterKeys {
        static let API_KEY          = "api_key"
        static let METHOD           = "method"
        static let SAFE_SEARCH      = "safe_search"
        static let EXTRAS           = "extras"
        static let FORMAT           = "format"
        static let NO_JSON_CALLBACK = "nojsoncallback"
        static let BBOX             = "bbox"
        static let PAGE             = "page"
        static let PER_PAGE         = "per_page"
        static let SORT             = "sort"
    }
    
    struct ParameterValues {
        static let JSON_FORMAT  = "json"
        static let URL_M        = "url_m"
    }
    
    struct BBoxParameters {
        static let BOUNDING_BOX_HALF_WIDTH = 1.0
        static let BOUNDING_BOX_HALF_HEIGHT = 1.0
        static let LAT_MIN = -90.0
        static let LAT_MAX = 90.0
        static let LON_MIN = -180.0
        static let LON_MAX = 180.0
    }
}

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
    
    
    static let sharedInstance = FlickrClient()
    
    private override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: GET Methods
    func taskForGETMethod(url: String?, parameters: [String : AnyObject]?, parseJSON: Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var urlString = (url != nil) ? url : Constants.BASE_URL
        if parameters != nil {
            var mutableParameters = parameters
            mutableParameters![ParameterKeys.API_KEY] = Constants.APIKey
            urlString = urlString! + FlickrClient.escapedParameters(mutableParameters!)
        }
        
        let url = NSURL(string: urlString!)!
        let request = NSURLRequest(URL: url)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, error: NSError(domain: "getTask", code: 2, userInfo: nil))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var errorCode = 0 /* technical error */
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    errorCode = response.statusCode
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(result: nil, error: NSError(domain: "getTask", code: errorCode, userInfo: nil))
                })
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, error: NSError(domain: "getTask", code: 3, userInfo: nil))
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if parseJSON {
                FlickrClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            } else {
                completionHandler(result: data, error: nil)
            }
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    

    
    // MARK: Helper Methods
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    /* Parsing JSON */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
}

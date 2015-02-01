//
//  APIController.swift
//  swift-study
//
//  Created by liszt on 1/31/15.
//  Copyright (c) 2015 Llhf. All rights reserved.
//

import Foundation

protocol APIControllerProtocol
{
    func didReceiveAPIResults(results: NSDictionary)
}

class APIController {
    var delegate: APIControllerProtocol
    init (delegate: APIControllerProtocol)
    {
        self.delegate = delegate

    }
    
    func searchItunesFor(searchTerm: String)
    {
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ",
            withString: "+",
            options: NSStringCompareOptions.CaseInsensitiveSearch,
            range: nil)
        
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            get(urlPath)
        }
    }
    
    func lookupAlbum(collectionId: Int)
    {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
    
    func get(path: String)
    {
        let url = NSURL(string: path)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("task completed")
            if error != nil
            {
                println(error.localizedDescription)
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if err != nil
            {
                println("json error \(err!.localizedDescription)")
            }
            
            let results: NSArray = jsonResult["results"] as NSArray
            self.delegate.didReceiveAPIResults(jsonResult)
            
        })
        
        task.resume()
    }
}

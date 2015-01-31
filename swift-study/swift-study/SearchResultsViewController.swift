//
//  ViewController.swift
//  swift-study
//
//  Created by liszt on 1/31/15.
//  Copyright (c) 2015 Llhf. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    @IBOutlet var appsTableView : UITableView?
    var tableData = []
    var api: APIController?
    var imageCache = [String: UIImage]()
    let kCellIdentifier: String = "SearchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        // Do any additional setup after loading the view, typically from a nib.
        api!.searchItunesFor("jq software")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "my-test")
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let rowdata: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        let cellText: String? = rowdata["trackName"] as? String
        cell.textLabel?.text = cellText
        cell.imageView?.image = UIImage(named: "Blank52")
        
        let formattedPrice: NSString = rowdata["formattedPrice"] as NSString
        
        
        let urlString: NSString = rowdata["artworkUrl60"] as NSString
        
        var image = self.imageCache[urlString]
        
        if (image == nil)
        {
            var imgURL: NSURL? = NSURL(string: urlString)
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
            NSURLConnection.sendAsynchronousRequest(
                request,
                queue: NSOperationQueue.mainQueue(),
                completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    if (error == nil)
                    {
                        image = UIImage(data: data)
                        
                        self.imageCache[urlString] = image
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath)
                            {
                                cellToUpdate.imageView?.image = image
                                // if tho following line emited, the image will not be updated
                                cellToUpdate.detailTextLabel?.text = "\(formattedPrice) "
                            }
                        })
                    }
                    else
                    {
                        println("Error: \(error.localizedDescription)")
                    }
            })
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath)
                {
                    cellToUpdate.imageView?.image = image
                }
            })
        }
        
        cell.detailTextLabel?.text = formattedPrice
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        var name: String = rowData["trackName"] as String
        var formattedPrice: String = rowData["formattedPrice"] as String
        
        var alert: UIAlertView = UIAlertView()
        alert.title = name
        alert.message = formattedPrice
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = resultsArr
            self.appsTableView?.reloadData()
        })
    }
}


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
    var api: APIController?
    var imageCache = [String: UIImage]()
    var albums = [Album]()
    
    let kCellIdentifier: String = "SearchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        // Do any additional setup after loading the view, typically from a nib.
        // show the loading icon
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchItunesFor("swift")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("the length of cells are: \(albums.count)")
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "my-test")
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let album = self.albums[indexPath.row]
        cell.textLabel?.text = album.title
        cell.imageView?.image = UIImage(named: "Blank52")
        
        let formattedPrice = album.price
        
        
        let urlString = album.thumbnailImageURL
        
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
                    // if tho following line emited, the image will not be updated
                    cellToUpdate.detailTextLabel?.text = "\(formattedPrice)  "
                }
            })
        }
        
        cell.detailTextLabel?.text = formattedPrice
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        return
        /*
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        var name: String = rowData["trackName"] as String
        var formattedPrice: String = rowData["formattedPrice"] as String
        
        var alert: UIAlertView = UIAlertView()
        alert.title = name
        alert.message = formattedPrice
        alert.addButtonWithTitle("OK")
        alert.show()*/
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(resultsArr)
            self.appsTableView?.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
        var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
        var selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }
}


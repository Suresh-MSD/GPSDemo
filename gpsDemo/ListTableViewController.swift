//
//  ListTableViewController.swift
//  gpsDemo
//
//  Created by Suresh D on 30/06/16.
//  Copyright © 2016 Suresh D. All rights reserved.
//

import UIKit

struct Section {
    
    var heading : String
    var items : [String]
    
    init(title: String, objects : [String]) {
        
        heading = title
        items = objects
    }
}

class ListTableViewController: UITableViewController {


    var sectionsArray = [Section]()

    var itemslast = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if appDelegate.indexCheck.isEqualToString("YesData") {
           requestResponse()
        }

        
        let defaults = NSUserDefaults.standardUserDefaults()
        let stringOne = defaults.stringForKey("response")
        
        let data = stringOne!.dataUsingEncoding(NSUTF8StringEncoding)!
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let dictionary = object as? [String: AnyObject] {
                self.readJSONObject(dictionary)
            }
        } catch {
            // Handle Error
        }
        print(appDelegate.objectResponse)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "LIST"
    }
    
    func requestResponse(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
       let request = NSMutableURLRequest(URL: NSURL(string: "http://surya-interview.appspot.com/list")!)
        request.HTTPMethod = "POST"
        let postString = "{\"emailId\": \"\(appDelegate.emailAddress!)\"}"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
            guard error == nil && data != nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(" ", forKey: "response")
            defaults.setValue((responseString!) as String, forKey: "response")
            let stringOne = defaults.stringForKey("response")
            let data = stringOne!.dataUsingEncoding(NSUTF8StringEncoding)!

            do {
                let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    self.readJSONObject(dictionary)
                }
            } catch {
                // Handle Error
            }

        }
        task.resume()

    }
    
    func readJSONObject(object: [String: AnyObject]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.objectResponse = object["items"] as? NSArray
        itemslast.removeAll()
        sectionsArray.removeAll()
        for user in appDelegate.objectResponse! {
            
            let emailid = user["emailId"] as? String
            let imageURL = user["imageUrl"] as? String
            let firstname = user["firstName"] as? String
            let lastname = user["lastName"] as? String
            
            let second = "\(firstname!) \(lastname!)"
            let askSome = Section(title: (second), objects: ["\(emailid!)", "\(imageURL!)"])
            
            sectionsArray.append(askSome)
        }
        itemslast = sectionsArray
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return itemslast[section].heading
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return itemslast.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return itemslast[section].items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = itemslast[indexPath.section].items[indexPath.row]
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

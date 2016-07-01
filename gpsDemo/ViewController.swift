//
//  ViewController.swift
//  gpsDemo
//
//  Created by Suresh D on 29/06/16.
//  Copyright © 2016 Suresh D. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTxt : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey("response") != nil
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.indexCheck = "YesData"
            let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ListTableViewController") ;
            let navController = UINavigationController(rootViewController: vc) // Creating a navigation controller with VC1 at the root of the navigation stack.
            dispatch_async(dispatch_get_main_queue(),{
                self.presentViewController(navController, animated: true, completion: nil)
            });
        }
    }
    
    @IBAction func enterFuntion (sender : UIButton?)
    {
        if(isValidEmail((emailTxt?.text)!))
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.emailAddress = "\(emailTxt!.text!)"
             let request = NSMutableURLRequest(URL: NSURL(string: "http://surya-interview.appspot.com/list")!)
            request.HTTPMethod = "POST"
            let postString = "{\"emailId\": \"\(appDelegate.emailAddress!)\"}"
            print(postString)
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
                defaults.setValue((responseString!) as String, forKey: "response")
                dispatch_async(dispatch_get_main_queue(),{
                    self.performSegueWithIdentifier("responseList", sender: self)
                });
            }
            task.resume()
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Enter the valid Email Address.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
        
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    

    /*   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     if "responseList" == segue.identifier {
     // Nothing really to do here, since it won't be fired unless
     // shouldPerformSegueWithIdentifier() says it's ok. In a real app,
     // this is where you'd pass data to the success view controller.
     }
     }
     
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


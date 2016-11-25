//
//  DetailViewController.swift
//  guestbook
//
//  Created by 倉井 一丸 on 2015/01/21.
//  Copyright (c) 2015年 倉井 一丸. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func add(sender: AnyObject) {
        
        var addpage : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("addpage")
        (addpage as AddPageViewController).note = self.noteId
        self.presentViewController(addpage as UIViewController, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var noteId: Int = 0
    
    var note: Int {
        get {   // ゲッター
            return noteId
        }
        set(id) {   // セッター
            noteId = id
        }
    }
    
    var pages = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pages.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
        cell.textLabel?.text = self.pages[indexPath.row]["description"] as NSString
        
        println(self.pages[indexPath.row]["description"])
        
        
        return cell
    }
    
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, CellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
        cell.textLabel?.text = "文字列"
        return cell

        
    }
*/

    /*
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
*/
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        getData()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewDidAppear() {
        getData()
    }
    
    // API取得の開始処理
    func getData() {
        let host = NSBundle.mainBundle().objectForInfoDictionaryKey("APIBaseURL") as String
        
        let URL = NSURL(string: host + "/api/page/get?id=" + String(self.noteId))
        let req = NSURLRequest(URL: URL!)
        let connection: NSURLConnection? = NSURLConnection(request: req, delegate: self, startImmediately: false)
        
        // NSURLConnectionを使ってAPIを取得する
        NSURLConnection.sendAsynchronousRequest(req,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: response)
    }
    
    // 取得したAPIデータの処理
    func response(res: NSURLResponse!, data: NSData!, error: NSError!){
        let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
        self.pages = json.objectForKey("response") as NSArray
        
        // １行ずつログに表示
        for var i=0 ; i<self.pages.count ; i++ {
            println(self.pages[i]["description"])
        }
        
        self.tableView.reloadData()
    }
    
    
    
}


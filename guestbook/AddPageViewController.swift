//
//  AddPageViewController.swift
//  guestbook
//
//  Created by 倉井 一丸 on 2015/03/20.
//  Copyright (c) 2015年 倉井 一丸. All rights reserved.
//

import UIKit
import Foundation

class AddPageViewController: UIViewController {
    
    var noteId: Int = 0
    
    var note: Int {
        get {   // ゲッター
            return noteId
        }
        set(id) {   // セッター
            noteId = id
        }
    }
    
    @IBOutlet weak var comment: UITextField!
    
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postComment(sender: AnyObject) {
        let host = NSBundle.mainBundle().objectForInfoDictionaryKey("APIBaseURL") as String
        
        let URL = NSURL(string: host + "/api/page/create?id=" + String(self.noteId) + "&description=" + self.comment.text!)
        let req = NSURLRequest(URL: URL!)
        let connection: NSURLConnection? = NSURLConnection(request: req, delegate: self, startImmediately: false)
        
        // NSURLConnectionを使ってAPIを取得する
        NSURLConnection.sendAsynchronousRequest(req,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: response)
    }
    
    // 取得したAPIデータの処理
    func response(res: NSURLResponse!, data: NSData!, error: NSError!){
        self.dismissViewControllerAnimated(true, completion: nil)
        /*
        let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
        self.pages = json.objectForKey("response") as NSArray
        
        // １行ずつログに表示
        for var i=0 ; i<self.pages.count ; i++ {
            println(self.pages[i]["description"])
        }
        
        self.tableView.reloadData()
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.noteId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
}


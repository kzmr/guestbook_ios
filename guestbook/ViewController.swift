//
//  ViewController.swift
//  guestbook
//
//  Created by 倉井 一丸 on 2015/01/21.
//  Copyright (c) 2015年 倉井 一丸. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // 現在地の位置情報の取得にはCLLocationManagerを使用
    var lm: CLLocationManager!
    // 取得した緯度を保持するインスタンス
    var latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // フィールドの初期化
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        // CLLocationManagerをDelegateに指定
        lm.delegate = self
        
        // 位置情報取得の許可を求めるメッセージの表示．必須．
        lm.requestAlwaysAuthorization()
        // 位置情報の精度を指定．任意，
        // lm.desiredAccuracy = kCLLocationAccuracyBest
        // 位置情報取得間隔を指定．指定した値（メートル）移動したら位置情報を更新する．任意．
        // lm.distanceFilter = 1000
        
        // GPSの使用を開始する
        lm.startUpdatingLocation()
        
        
        // api test
        //getData()
        
        //var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.665213,139.730011)
        
        //let myLatDist : CLLocationDistance = 10
        //let myLonDist : CLLocationDistance = 10
        //let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, myLatDist, myLonDist);
        
        /*

        let span = MKCoordinateSpanMake(0.5, 0.5)
        var myRegion = MKCoordinateRegionMake(centerCoordinate, span)
        
        self.mapView.setRegion(myRegion,animated:true)
        
        var mapPoint:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.655,139.748)
        
        //ピンを生成
        var theRoppongiAnnotation = MKPointAnnotation()
        //ピンを置く場所を設定
        theRoppongiAnnotation.coordinate  = mapPoint
        //ピンのタイトルの設定
        theRoppongiAnnotation.title       = "Tokyo Tower"
        //ピンのサブタイトルを設定
        theRoppongiAnnotation.subtitle    = "ワイルドだろぅ〜？"
        //ピンを地図上に追加
        self.mapView.addAnnotation(theRoppongiAnnotation)
        
        
        var mapPoint1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.710,139.810)
        
        //ピンを生成
        var theRoppongiAnnotation1 = MKPointAnnotation()
        //ピンを置く場所を設定
        theRoppongiAnnotation1.coordinate  = mapPoint1
        //ピンのタイトルの設定
        theRoppongiAnnotation1.title       = "Tokyo Skytree"
        //ピンのサブタイトルを設定
        theRoppongiAnnotation1.subtitle    = "ワイルドだろぅ〜？"
        //ピンを地図上に追加
        self.mapView.addAnnotation(theRoppongiAnnotation1)
        
        
        // Tokyo Tower
        //tt.sample = @"35.655, 139.748";
        
        // Tokyo Skytree
        //st.sample = @"35.710, 139.810";
        
        // add annotations to map
        //[map_ addAnnotations:@[tt, st]];
        
        
        
        */
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // API取得の開始処理
    func getData() {
        //let URL = NSURL(string: "http://express.heartrails.com/api/json?method=getPrefectures")
        let host = NSBundle.mainBundle().objectForInfoDictionaryKey("APIBaseURL") as String
        
        println(host)
        
        let URL = NSURL(string: host + "/api/note/search")
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
        let notes:NSArray = json.objectForKey("response") as NSArray
        
        // １行ずつログに表示
        for var i=0 ; i<notes.count ; i++ {
            var lat: Double = (notes[i]["latitude"] as NSString).doubleValue
            var lng: Double = (notes[i]["longitude"] as NSString).doubleValue
            var mapPoint1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
            
            //ピンを生成
            var theRoppongiAnnotation1 = CustomMKPointAnnotation()
            //ピンを置く場所を設定
            theRoppongiAnnotation1.coordinate = mapPoint1
            //ピンのタイトルの設定
            theRoppongiAnnotation1.title = (notes[i]["title"] as NSString)
            //ピンのサブタイトルを設定
            theRoppongiAnnotation1.subtitle = (notes[i]["title"] as NSString)
            
            theRoppongiAnnotation1.senderTag = (notes[i]["id"] as Int)
            
            //ピンを地図上に追加
            self.mapView.addAnnotation(theRoppongiAnnotation1)
        }
        
    }
    
    /* 位置情報取得成功時に実行される関数 */
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        
        //NSLog("latiitude: \(latitude) , longitude: \(longitude)")
        
        //地図の中心地を決定
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        let span = MKCoordinateSpanMake(0.1, 0.1)
        var myRegion = MKCoordinateRegion(center: location, span: span);
        self.mapView.setRegion(myRegion, animated:false)

        //ピンを地図上に追加
        var mapPoint1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude)
        var theRoppongiAnnotation1 = CustomMKPointAnnotation()
        theRoppongiAnnotation1.coordinate = mapPoint1
        theRoppongiAnnotation1.title = "現在地"
        theRoppongiAnnotation1.subtitle = "あなたはここですね？"
        theRoppongiAnnotation1.senderTag = 0
        self.mapView.addAnnotation(theRoppongiAnnotation1)
        
        // apiで表示データ取得
        getData()
        
        // GPSの使用を停止する．停止しない限りGPSは実行され，指定間隔で更新され続ける．
        lm.stopUpdatingLocation()
    }
    
    
    
    /* 位置情報取得失敗時に実行される関数 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // この例ではLogにErrorと表示するだけ．
        NSLog("Error")
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            
            let reuseId = "pin"
        
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.pinColor = .Purple
                
                /* button自作
                let button = UIButton()
                button.setTitle("Tap Me!", forState: .Normal)
                button.frame = CGRectMake(0, 0, 50, 50)
                button.backgroundColor = UIColor(red: 0.7, green: 0.2, blue: 0.2, alpha: 0.2)
                pinView!.leftCalloutAccessoryView = button;
                */
                

                let detailButton: UIButton = UIButton.buttonWithType(.DetailDisclosure) as UIButton
                detailButton.tag = (annotation as CustomMKPointAnnotation).senderTag
                detailButton.layer.position = CGPoint(x:50, y:50)
                detailButton.addTarget(self, action: "tapped:", forControlEvents: .TouchUpInside)
                
                
                pinView!.leftCalloutAccessoryView = detailButton;
                
                
                //var imageview = UIImageView(frame: CGRectMake(0, 0, 45, 45))
                //pinView!.leftCalloutAccessoryView = imageview
                
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
    }
    
    func tapped(sender: AnyObject) {
        var detail : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("detail")
        (detail as DetailViewController).note = sender.tag
        self.presentViewController(detail as UIViewController, animated: true, completion: nil)
    }
}
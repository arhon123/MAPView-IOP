//
//  ViewController.swift
//  IOP
//
//  Created by D7703_18 on 2017. 9. 18..
//  Copyright © 2017년 D7703_18. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var myMapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locateToCenter()
        
        ///////// plist data 가져오기
        // 패스 = 위치, 번들 = 파일시스템
        let path = Bundle.main.path(forResource: "ViewPoint", ofType: "plist")
        print("path = \(String(describing :path))")
        
        let contents = NSArray(contentsOfFile: path!)
        // NSArray는 모든 타입이 다 들어가있다
        print("contents = \(String(describing: contents))")
        
        // pin point를 저장하기 위한 배열 선언
        var annotations = [MKPointAnnotation]()
        
        
        // 값 뽑아오기 contents(딕셔너리의 배열)에서 데이터 뽑아오기
        if let myItems = contents {
            for item in myItems {
                let lat = (item as AnyObject).value(forKey: "lat")
                let long = (item as AnyObject).value(forKey: "long")
                let title = (item as AnyObject).value(forKey: "title")
                let subTitle = (item as AnyObject).value(forKey: "subTitle")
                
                print("let = \(String(describing: lat))")
                
                let annotation = MKPointAnnotation()
                
                let myLat = (lat as! NSString).doubleValue
                let myLong = (long as! NSString).doubleValue
                let myTitle = title as! String
                let mySubTitle = subTitle as! String
                
                annotation.coordinate.latitude = myLat
                annotation.coordinate.longitude = myLong
                annotation.title = myTitle
                annotation.subtitle = mySubTitle
                
                annotations.append(annotation)
                myMapView.delegate = self
            }
            
        } else {
            print("contents nil")
        }
        
        myMapView.addAnnotations(annotations)
        myMapView.showAnnotations(annotations, animated: true)
        
        
    }

    
    func locateToCenter() {
        let center = CLLocationCoordinate2DMake(35.166197, 129.072594)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(center, span)
        myMapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        var annotationView = myMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            if annotation.title! == "부산시민공원" {
                // 부산시민공원
                annotationView?.pinTintColor = UIColor.green

            } else if annotation.title! == "DIT 동의과학대학교" {
                // 동의과학대학교
            } else {
                // 송상현광장
                annotationView?.pinTintColor = UIColor.blue
            }
        } else {
            annotationView?.annotation = annotation
        }
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = btn
        
        return annotationView
        
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("callout Accessory Tapped!")
        
        let viewAnno = view.annotation
        let viewTitle: String = ((viewAnno?.title)!)!
        let viewSubTitle: String = ((viewAnno?.subtitle)!)!
        
        print("\(viewTitle) \(viewSubTitle)")
        
        let ac = UIAlertController(title: viewTitle, message: viewSubTitle, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


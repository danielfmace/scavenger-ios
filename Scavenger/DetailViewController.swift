//
//  DetailViewController.swift
//  Scavenger
//
//  Created by Daniel Mace on 11/4/15.
//
//

import UIKit
import MapKit
import AddressBook


class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var event: Event?
    
    let regionRadius: CLLocationDistance = 1000
    
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
        if let event = event {
            navigationItem.title = event.name
            if event.photo != nil {
                event.photo!.getDataInBackgroundWithBlock { data, error in
                    if let data = data, image = UIImage(data: data) {
                        self.photoImageView.image = image
                    }
                }
            }
            else {
                self.photoImageView.image = UIImage(named: "defaultPhoto")
            }
            descriptionLabel.text = event.info
            timeLabel.text = event.time
            dateLabel.text = event.date
            location = CLLocation(latitude: event.location.latitude, longitude: event.location.longitude)
            centerMapOnLocation(location!)
            
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = (location?.coordinate)!
            dropPin.title = event.name
            
            mapView.addAnnotation(dropPin)
            
        }
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        // Below condition is for custom annotation
        /*
        if (annotation.isKindOfClass(CustomAnnotation)) {
            let customAnnotation = annotation as? CustomAnnotation
            mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation") as MKAnnotationView!
            
            if (annotationView == nil) {
                annotationView = customAnnotation?.annotationView()
            } else {
                annotationView.annotation = annotation;
            }
            
            self.addBounceAnimationToView(annotationView)
            return annotationView
        } else {
            return nil
        }
        */
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

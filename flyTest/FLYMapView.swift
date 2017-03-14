//
//  FLYMapView.swift
//  flyTest
//
//  Created by vivek verma on 14/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit
import MapKit

class FLYMapView: UIView {
    let regionRadius: CLLocationDistance = 30000
    
    var mapView : MKMapView?
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.p_initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    //MARK: - public methods
    
    func updateCurrentLocation(latitude : Double, longitude : Double) {
        mapView?.removeAnnotations((mapView?.annotations)!)
        let location : CLLocation = CLLocation.init(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: location)
    }
    
    func updateMapWithArtWorks(agents : [Agent]) {
        var annotations : [MKPointAnnotation] = [MKPointAnnotation]()
        for agent in agents {
            let annotation : MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: (agent.coordinates?.latitude)!, longitude: (agent.coordinates?.longitude)!)
            annotation.title = agent.name
            annotation.subtitle =  (agent.location?.displayAddress?.count)! > 0 ? agent.location?.displayAddress?.joined(separator: ",") : ""
            annotations.append(annotation)
        }
        mapView?.addAnnotations(annotations)
        mapView?.addAnnotation((mapView?.userLocation)!)
    }
    
    //MARK: - private methods
    
    private func p_initSubviews() {
        mapView = MKMapView()
        mapView?.delegate = self
        self.addSubview(mapView!)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
}

extension FLYMapView : MKMapViewDelegate {

}

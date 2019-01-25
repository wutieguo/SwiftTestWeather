//
//  MapViewController.swift
//  Weather
//
//  Created by Tieguo Wu on 1/25/19.
//  Copyright © 2019 Tieguo Wu. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    
    var locationManager: CLLocationManager! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setZoomLevel(3.0, animated: false)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        mapView.addGestureRecognizer(doubleTapGesture)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    @objc func onTap(_ doubleTapGesture: UITapGestureRecognizer) {
        let point = doubleTapGesture.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        viewController.coordinate = coordinate
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onBtnHistory(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.setCenter(location.coordinate, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    
}

extension MapViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

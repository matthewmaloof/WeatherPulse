//
//  LocationManager.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, LocationManagerProtocol {
    var delegate: CLLocationManagerDelegate? {
            didSet {
                manager.delegate = delegate
            }
        }
        var manager: CLLocationManager

    override init() {
            self.manager = CLLocationManager()
        }

    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func requestAlwaysAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    func requestLocation() {
        manager.requestLocation()
    }
}

protocol LocationManagerType: AnyObject {
    var delegate: CLLocationManagerDelegate? { get set }
    func requestWhenInUseAuthorization()
    func requestAlwaysAuthorization()
    func requestLocation()
}
extension CLLocationManager: LocationManagerType {}

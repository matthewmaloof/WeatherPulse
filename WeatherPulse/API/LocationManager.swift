//
//  LocationManager.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import Foundation
import CoreLocation

class LocationManager: LocationManagerProtocol {
    var delegate: CLLocationManagerDelegate?
    var manager: CLLocationManager

    init() {
        self.manager = CLLocationManager()
        self.manager.delegate = delegate
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

//
//  LocationManagerProtocol.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import CoreLocation

protocol LocationManagerProtocol: CLLocationManagerDelegate {
    var delegate: CLLocationManagerDelegate? { get set }
    func requestWhenInUseAuthorization()
    func requestLocation()
    func requestAlwaysAuthorization()
}

// Make CLLocationManager conform to our protocol
extension CLLocationManager: LocationManagerProtocol { }

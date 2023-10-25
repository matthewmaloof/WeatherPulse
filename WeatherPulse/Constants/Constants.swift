//
//  Constants.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/25/23.
//

import Foundation

struct Constants {
    
    static let allCities: [String] = ["San Francisco", "New York", "Chicago", "Los Angeles", "Miami",
                               "Houston", "Boston", "Denver", "Seattle", "Atlanta",
                               "Nashville", "Las Vegas", "Portland", "Philadelphia", "Orlando",
                               "Dallas", "Phoenix", "Austin", "San Diego", "Indianapolis",
                               "Columbus", "San Antonio", "Jacksonville", "Charlotte", "Detroit"]
    
    static let allCitiesWithCoordinates: [CityWithCoordinates] = [
        CityWithCoordinates(name: "San Francisco", latitude: 37.7749, longitude: -122.4194),
        CityWithCoordinates(name: "New York", latitude: 40.7128, longitude: -74.0060),
        CityWithCoordinates(name: "Chicago", latitude: 41.8781, longitude: -87.6298),
        CityWithCoordinates(name: "Los Angeles", latitude: 34.0522, longitude: -118.2437),
        CityWithCoordinates(name: "Miami", latitude: 25.7617, longitude: -80.1918),
        CityWithCoordinates(name: "Houston", latitude: 29.7604, longitude: -95.3698),
        CityWithCoordinates(name: "Boston", latitude: 42.3601, longitude: -71.0589),
        CityWithCoordinates(name: "Denver", latitude: 39.7392, longitude: -104.9903),
        CityWithCoordinates(name: "Seattle", latitude: 47.6062, longitude: -122.3321),
        CityWithCoordinates(name: "Atlanta", latitude: 33.7490, longitude: -84.3880),
        CityWithCoordinates(name: "Nashville", latitude: 36.1627, longitude: -86.7816),
        CityWithCoordinates(name: "Las Vegas", latitude: 36.1699, longitude: -115.1398),
        CityWithCoordinates(name: "Portland", latitude: 45.5122, longitude: -122.6587),
        CityWithCoordinates(name: "Philadelphia", latitude: 39.9526, longitude: -75.1652),
        CityWithCoordinates(name: "Orlando", latitude: 28.5383, longitude: -81.3792),
        CityWithCoordinates(name: "Dallas", latitude: 32.7767, longitude: -96.7970),
        CityWithCoordinates(name: "Phoenix", latitude: 33.4484, longitude: -112.0740),
        CityWithCoordinates(name: "Austin", latitude: 30.2672, longitude: -97.7431),
        CityWithCoordinates(name: "San Diego", latitude: 32.7157, longitude: -117.1611),
        CityWithCoordinates(name: "Indianapolis", latitude: 39.7684, longitude: -86.1581),
        CityWithCoordinates(name: "Columbus", latitude: 39.9612, longitude: -82.9988),
        CityWithCoordinates(name: "San Antonio", latitude: 29.4241, longitude: -98.4936),
        CityWithCoordinates(name: "Jacksonville", latitude: 30.3322, longitude: -81.6557),
        CityWithCoordinates(name: "Charlotte", latitude: 35.2271, longitude: -80.8431),
        CityWithCoordinates(name: "Detroit", latitude: 42.3314, longitude: -83.0458),
    ]
    
    static let apiKey = "9a886f58ffc36fd81c83212ab386e366"
}

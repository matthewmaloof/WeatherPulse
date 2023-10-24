//
//  WeatherViewModel.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import Combine
import CoreLocation

class WeatherViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    private var api: WeatherAPIProtocol
    private var locationManager: LocationManagerProtocol
    
    @Published var currentLocation: CLLocation?
    @Published var weatherData: WeatherModel?
    @Published var locationPermissionGranted: Bool = false
    @Published var locationError: Error?
    @Published var apiError: Error?
    @Published var currentWeather: CurrentWeather?
    @Published var dailyWeather: [DailyWeather]?
    @Published var isLoading: Bool = false
    
    
    var cancellables = Set<AnyCancellable>()
    
    init(api: WeatherAPIProtocol, locationManager: LocationManagerProtocol) {
        self.api = api
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        api.fetchWeather(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)  //To run on main thread
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.apiError = error
                case .finished:
                    break
                }
            } receiveValue: { weather in
                self.weatherData = weather
            }
            .store(in: &cancellables)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                self.currentLocation = location
                // Fetch weather using the latitude and longitude from `currentLocation`
                fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError = error
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermissionGranted = (status == .authorizedWhenInUse || status == .authorizedAlways)
    }
}

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
    
    var currentLocationPublisher: AnyPublisher<CLLocation?, Never> {
        return $currentLocation
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    @Published var currentLocation: CLLocation?
    @Published var weatherData: WeatherModel?
    @Published var locationPermissionGranted: Bool = false
    @Published var locationError: Error?
    @Published var apiError: Error?
    @Published var currentWeather: CurrentWeather?
    
    @Published var dailyWeather: [DailyWeather]?
    @Published var isLoading: Bool = false
    @Published var cities = ["San Francisco", "New York", "Chicago", "Los Angeles", "Miami",
                             "Houston", "Boston", "Denver", "Seattle", "Atlanta",
                             "Nashville", "Las Vegas", "Portland", "Philadelphia", "Orlando",
                             "Dallas", "Phoenix", "Austin", "San Diego", "Indianapolis",
                             "Columbus", "San Antonio", "Jacksonville", "Charlotte", "Detroit"]
    @Published var uiState: UIState = .loading
    @Published var error: APIError?
    private var cancellables = Set<AnyCancellable>()
    private var weatherAPI: WeatherAPIProtocol
    
    
    init(api: WeatherAPIProtocol, locationManager: LocationManagerProtocol) {
        self.api = api
        self.locationManager = locationManager
        
        self.weatherAPI = WeatherAPI()
        super.init()
        DispatchQueue.main.async {
            self.uiState = .success
        }
        
        self.locationManager.delegate = self
        currentLocationPublisher
            .compactMap { $0 }
            .sink { [weak self] newLocation in
                self?.fetchWeather(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
            }
            .store(in: &cancellables)
    }
    
    
    func fetchWeather(latitude: Double, longitude: Double) {
        weatherAPI.fetchWeather(latitude: latitude, longitude: longitude)
            .print("Debug: ")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("FINISHED WITH: \(completion)")
                    break
                case .failure(let apiError):
                    print("Failed: \(apiError)")
                    self.error = apiError
                }
            } receiveValue: { [weak self] weatherModel in
                print("Received weather: \(weatherModel)")
                
                DispatchQueue.main.async {
                    self?.weatherData = weatherModel
                    self?.currentWeather = weatherModel.current
                }
            }
            .store(in: &cancellables)
    }
    
    
    func fetchDailyWeather(latitude: Double, longitude: Double) {
        let publisher = api.fetchDailyWeather(latitude: latitude, longitude: longitude)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch daily weather: \(error)")
                }
            }, receiveValue: { [weak self] dailyWeather in
                self?.dailyWeather = dailyWeather
            })
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

extension WeatherViewModel {
    func kelvinToFahrenheit(_ kelvin: Double) -> Double {
        return (kelvin - 273.15) * 9/5 + 32
    }
}

enum UIState {
    case loading
    case success
    case error(String)
}

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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentLocation: CLLocation?
    @Published var weatherData: WeatherModel?
    @Published var locationPermissionGranted: Bool = false
    @Published var error: Error?
    @Published var uiState: UIState = .loading
    @Published var locationError: Error?
    @Published var dailyWeather: [DailyWeather]?

    var currentWeather: CurrentWeather? {
        return weatherData?.current
    }
    
    var locationManager: LocationManagerType
    
    
    init(api: WeatherAPIProtocol, locationManager: LocationManagerType) {
        self.api = api
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        uiState = .success
        print("ViewModel Initialized")
    }

    func fetchWeatherData<T: Decodable>(latitude: Double, longitude: Double, endpointType: EndpointType, decodingType: T.Type) {
        precondition(T.self is WeatherModel.Type || T.self is [DailyWeather].Type, "Unsupported type")

        print("Fetching data for latitude: \(latitude), longitude: \(longitude), endpoint: \(endpointType), decodingType: \(decodingType)")

        let publisher = api.fetch(latitude: latitude, longitude: longitude, for: endpointType, decodingType: T.self)
        publisher
            .print("Debugging Publisher")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("Finished fetching weather data")
                case .failure(let apiError):
                    print("Failed with error: \(apiError), localizedDescription: \(apiError.localizedDescription)")
                    self?.error = apiError
                    self?.uiState = .error(apiError.localizedDescription)
                }
            } receiveValue: { [weak self] (decodedData: T) in
                self?.handleReceivedData(decodedData)
            }
            .store(in: &cancellables)
    }

    private func handleReceivedData<T: Decodable>(_ data: T) {
        if let weatherModel = data as? WeatherModel {
            self.weatherData = weatherModel
            self.dailyWeather = weatherModel.daily // Handling the daily weather
            self.uiState = .success
        } else {
            print("Unexpected data type received: \(type(of: data))")
            self.uiState = .error("Unexpected data type")
        }
    }


    
    
    @nonobjc func locationManager<T: LocationManagerProtocol>(_ manager: T, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
            fetchWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, endpointType: .current, decodingType: WeatherModel.self)
            fetchWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, endpointType: .daily, decodingType: WeatherModel.self)
        }
    }
    
    
    @nonobjc func locationManager<T: LocationManagerProtocol>(_ manager: T, didFailWithError error: Error) {
        self.locationError = error
    }
    
    @nonobjc func locationManager<T: LocationManagerProtocol>(_ manager: T, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermissionGranted = (status == .authorizedWhenInUse || status == .authorizedAlways)
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
}

extension Double {
    func kelvinToFahrenheit() -> Double {
        return (self - 273.15) * 9/5 + 32
    }
}

enum UIState {
    case loading
    case success
    case error(String)
}

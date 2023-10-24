////
////  WeatherPulseTests.swift
////  WeatherPulseTests
////
////  Created by Matthew Maloof on 10/23/23.
////
//
//import XCTest
//import Combine
//import CoreLocation
//@testable import WeatherPulse
//
//class WeatherPulseTests: XCTestCase {
//    var viewModel: WeatherViewModel!
//    var mockAPI: MockWeatherAPI!
//    var mockLocationManager: MockLocationManager!
//    var cancellables: Set<AnyCancellable> = []
//    
//    override func setUp() {
//        super.setUp()
//        mockAPI = MockWeatherAPI()
//        mockLocationManager = MockLocationManager()
//        viewModel = WeatherViewModel(api: mockAPI, locationManager: mockLocationManager)
//    }
//    
//    func testLocationErrorHandling() {
//        let expect = expectation(description: "Location error handled")
//        let simulatedError = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Expected Error"])
//        
//        viewModel.$locationError.sink { error in
//            if let error = error {
//                XCTAssertEqual(error.localizedDescription, simulatedError.localizedDescription)
//                expect.fulfill()
//            }
//        }.store(in: &cancellables)
//        
//        mockLocationManager.simulateLocationFailure(with: simulatedError)
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    func testWeatherFetching() {
//        let expect = expectation(description: "Weather data fetched")
//        
//        viewModel.$weatherData.sink { data in
//            if data != nil {
//                expect.fulfill()
//            }
//        }.store(in: &cancellables)
//        
//        mockAPI.shouldFail = false
//        mockLocationManager.simulateSuccessfulLocationUpdate()
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    func testAPIErrorHandling() {
//        let expect = expectation(description: "API error handled")
//        
//        viewModel.$apiError.sink { error in
//            if error != nil {
//                expect.fulfill()
//            }
//        }.store(in: &cancellables)
//        
//        mockAPI.shouldFail = true
//        mockLocationManager.simulateSuccessfulLocationUpdate()
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    func testLocationManagerDidChangeAuthorization() {
//        let mockAPI = MockWeatherAPI()
//        let mockLocationManager = MockLocationManager()
//        
//        let viewModel = WeatherViewModel(api: mockAPI, locationManager: mockLocationManager)
//        mockLocationManager.delegate = viewModel
//        
//        // Test: Change to .authorizedWhenInUse
//        mockLocationManager.simulateAuthorizationChange(to: .authorizedWhenInUse)
//        XCTAssertTrue(viewModel.locationPermissionGranted)
//        
//        // Test: Change to .denied
//        mockLocationManager.simulateAuthorizationChange(to: .denied)
//        XCTAssertFalse(viewModel.locationPermissionGranted)
//    }
//    
//}
//
//
//class MockWeatherAPI: WeatherAPIProtocol {
//    
//    var shouldFail = false
//    
//    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherModel, APIError> {
//        
//        if shouldFail {
//            return Fail(error: APIError.network(description: "Simulated Network Error"))
//                .eraseToAnyPublisher()
//        }
//        
//        let weather = WeatherModel(
//            current: CurrentWeather(dt: 1634755395, temp: 298.33, weather: [Weather(main: "Clear", icon: "01d")]),
//            daily: [DailyWeather(dt: 1634755395, temp: Temp(min: 295, max: 299), weather: [Weather(main: "Clear", icon: "01d")])]
//        )
//        
//        return Just(weather)
//            .setFailureType(to: APIError.self)
//            .eraseToAnyPublisher()
//    }
//}
//
//class MockLocationManager: LocationManagerProtocol {
//    var delegate: CLLocationManagerDelegate?
//    
//    
//    func requestWhenInUseAuthorization() {
//        delegate?.locationManager?(CLLocationManager(), didChangeAuthorization: .authorizedWhenInUse)
//    }
//    
//    func simulateAuthorizationChange(to status: CLAuthorizationStatus) {
//        delegate?.locationManager?(CLLocationManager(), didChangeAuthorization: status)
//    }
//    
//    func requestAlwaysAuthorization() {
//        delegate?.locationManager?(CLLocationManager(), didChangeAuthorization: .authorizedAlways)
//    }
//    
//    func requestLocation() {
//        let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
//        delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [mockLocation])
//    }
//    
//    func simulateLocationFailure(with error: Error) {
//        delegate?.locationManager?(CLLocationManager(), didFailWithError: error)
//    }
//    
//    // Method to simulate successful location update
//    func simulateSuccessfulLocationUpdate() {
//        let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
//        delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [mockLocation])
//    }
//}

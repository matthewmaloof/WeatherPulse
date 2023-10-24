//
//  WeatherPulseTests.swift
//  WeatherPulseTests
//
//  Created by Matthew Maloof on 10/23/23.
//

import XCTest
import Combine
import CoreLocation
@testable import WeatherPulse

class WeatherViewModelTests: XCTestCase {
    
    var sut: WeatherViewModel!
    var mockWeatherAPI: MockWeatherAPI!
    var mockLocationManager: MockLocationManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockWeatherAPI = MockWeatherAPI()
        mockLocationManager = MockLocationManager()
        if let unwrappedMockLocationManager = mockLocationManager {
            sut = WeatherViewModel(api: mockWeatherAPI, locationManager: unwrappedMockLocationManager)
        }
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockWeatherAPI = nil
        mockLocationManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    
    func testRequestWhenInUseAuthorizationCallsLocationManager() {
        sut.requestWhenInUseAuthorization()
        
        XCTAssertTrue(mockLocationManager.didRequestWhenInUseAuthorization)
    }
    
    func testRequestAlwaysAuthorizationCallsLocationManager() {
        sut.requestAlwaysAuthorization()
        
        XCTAssertTrue(mockLocationManager.didRequestAlwaysAuthorization)
    }
    
    func testFetchDailyWeatherSuccess() {
        // Given
        let jsonData = """
                   [
                       {
                           "dt": 1633027200,
                           "temp": {
                               "min": 289.82,
                               "max": 295.67
                           },
                           "weather": [
                               {
                                   "main": "Clouds",
                                   "icon": "04d"
                               }
                           ]
                       }
                   ]
               """.data(using: .utf8)!
        
        let expectedDailyWeather: [DailyWeather] = try! JSONDecoder().decode([DailyWeather].self, from: jsonData)
        mockWeatherAPI.fetchDailyWeatherResult = .success(expectedDailyWeather)
        
        
        let expectation = XCTestExpectation(description: "Fetch Daily Weather Successful")
        sut.$dailyWeather
            .dropFirst()
            .sink { receivedDailyWeather in
                XCTAssertEqual(receivedDailyWeather, expectedDailyWeather)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.fetchDailyWeather(latitude: 12.34, longitude: 56.78)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLocationManagerDidUpdateLocations() {
        // Given
        let location = CLLocation(latitude: 12.34, longitude: 56.78)
        
        let expectation = XCTestExpectation(description: "Did update locations")
        sut.$currentLocation
            .dropFirst()
            .sink { newLocation in
                XCTAssertEqual(newLocation?.coordinate.latitude, 12.34)
                XCTAssertEqual(newLocation?.coordinate.longitude, 56.78)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.locationManager(mockLocationManager, didUpdateLocations: [location])
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLocationManagerDidFailWithError() {
        // Given
        let error = NSError(domain: "LocationError", code: 1234, userInfo: nil)
        
        let expectation = XCTestExpectation(description: "Did fail with error")
        sut.$locationError
            .dropFirst()
            .sink { receivedError in
                XCTAssertEqual((receivedError as NSError?)?.code, 1234)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.locationManager(mockLocationManager, didFailWithError: error)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLocationManagerDidChangeAuthorization() {
        // Given
        let status: CLAuthorizationStatus = .authorizedWhenInUse
        
        let expectation = XCTestExpectation(description: "Did change authorization")
        sut.$locationPermissionGranted
            .dropFirst()
            .sink { isGranted in
                XCTAssertTrue(isGranted)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.locationManager(mockLocationManager, didChangeAuthorization: status)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testKelvinToFahrenheitConversion() {
        let kelvin = 300.0
        let fahrenheit = sut.kelvinToFahrenheit(kelvin)
        
        XCTAssertEqual(fahrenheit, 80.33, accuracy: 0.01)
    }
    
}


class MockLocationManager: NSObject, LocationManagerType, LocationManagerProtocol {
    var delegate: CLLocationManagerDelegate?
    
    // Flags to keep track of whether methods were called
    var didRequestWhenInUseAuthorization = false
    var didRequestAlwaysAuthorization = false
    var didRequestLocation = false
    
    func requestWhenInUseAuthorization() {
        didRequestWhenInUseAuthorization = true
    }
    
    func requestAlwaysAuthorization() {
        didRequestAlwaysAuthorization = true
    }
    
    func requestLocation() {
        didRequestLocation = true
    }
}

class MockWeatherAPI: WeatherAPIProtocol {
    var fetchWeatherResult: Result<WeatherModel, APIError> = .failure(.dataNotFound)
    var fetchDailyWeatherResult: Result<[DailyWeather], APIError> = .failure(.dataNotFound)
    
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherModel, APIError> {
        return Future<WeatherModel, APIError> { promise in
            promise(self.fetchWeatherResult)
        }
        .eraseToAnyPublisher()
    }
    
    func fetchDailyWeather(latitude: Double, longitude: Double) -> AnyPublisher<[DailyWeather], APIError> {
        return Future<[DailyWeather], APIError> { promise in
            promise(self.fetchDailyWeatherResult)
        }
        .eraseToAnyPublisher()
    }
}

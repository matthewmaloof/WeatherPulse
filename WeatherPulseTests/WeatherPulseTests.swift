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
        sut = WeatherViewModel(api: mockWeatherAPI, locationManager: mockLocationManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockWeatherAPI = nil
        mockLocationManager = nil
        cancellables.removeAll()
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
    
    func performTestOnPublisher<T: Publisher>(
        _ publisher: T,
        expectation: XCTestExpectation,
        cancellables: inout Set<AnyCancellable>,
        receiveValue: @escaping (T.Output) -> Void
    ) where T.Failure == Never {
        publisher
            .dropFirst()
            .sink(receiveValue: { value in
                receiveValue(value)
                expectation.fulfill()
            })
            .store(in: &cancellables)
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
        mockWeatherAPI.fetchResult = .success(expectedDailyWeather)
        
        let expectation = XCTestExpectation(description: "Fetch Daily Weather Successful")
        
        // Using performTestOnPublisher function
        performTestOnPublisher(
            sut.$dailyWeather,  // Make sure dailyWeather is an @Published property in WeatherViewModel
            expectation: expectation,
            cancellables: &cancellables
        ) { receivedDailyWeather in
            XCTAssertEqual(receivedDailyWeather, expectedDailyWeather)
        }
        
        // When
        sut.fetchWeatherData(latitude: 12.34, longitude: 56.78, endpointType: .daily, decodingType: [DailyWeather].self)

        // Then
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    
    func testLocationManagerDidUpdateLocations() {
        // Given
        let location = CLLocation(latitude: 12.34, longitude: 56.78)
        
        let expectation = XCTestExpectation(description: "Did update locations")
        performTestOnPublisher(
            sut.$currentLocation,
            expectation: expectation,
            cancellables: &cancellables
        ) { receivedLocation in
            XCTAssertEqual(receivedLocation, location)
        }

    }
    
//    func testLocationManagerDidFailWithError() {
//        // Given
//        let error = NSError(domain: "LocationError", code: 1234, userInfo: nil)
//        
//        // When & Then
//        performTestOnPublisher(
//            publisher: sut.$locationError,
//            expectedResult: error,
//            description: "Did fail with error"
//        )
//    }
//    
//    func testLocationManagerDidChangeAuthorization() {
//        // Given
//        let status: CLAuthorizationStatus = .authorizedWhenInUse
//        
//        // When & Then
//        performTestOnPublisher(
//            publisher: sut.$locationPermissionGranted,
//            expectedResult: true,
//            description: "Did change authorization"
//        )
//    }
    
}

// Mock classes
class MockLocationManager: NSObject, LocationManagerType, LocationManagerProtocol {
    func requestLocation() {
        print("")
    }
    
    var delegate: CLLocationManagerDelegate?
    
    var didRequestWhenInUseAuthorization = false
    var didRequestAlwaysAuthorization = false
    
    func requestWhenInUseAuthorization() {
        didRequestWhenInUseAuthorization = true
    }
    
    func requestAlwaysAuthorization() {
        didRequestAlwaysAuthorization = true
    }
}

class MockWeatherAPI: WeatherAPIProtocol {
    var fetchResult: Result<Decodable, APIError> = .failure(.dataNotFound)
    
    func fetch<T: Decodable>(latitude: Double, longitude: Double, for endpoint: EndpointType, decodingType: T.Type) -> AnyPublisher<T, APIError> {
        return Future<T, APIError> { [weak self] promise in
            if case .success(let value) = self?.fetchResult, let decodedValue = value as? T {
                promise(.success(decodedValue))
            } else if case .failure(let error) = self?.fetchResult {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

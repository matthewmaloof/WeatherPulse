//
//  WeatherAPI.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import Combine
import Foundation

class WeatherAPI: WeatherAPIProtocol {
    
    private let apiKey = "9a886f58ffc36fd81c83212ab386e366"
    static let shared = WeatherAPI()
    
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherModel, APIError> {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    throw APIError.invalidStatusCode(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                }
                return APIError.jsonParsingError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchDailyWeather(latitude: Double, longitude: Double) -> AnyPublisher<[DailyWeather], APIError> {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,hourly&appid=\(apiKey)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    throw APIError.invalidStatusCode(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .map { weatherModel in
                return weatherModel.daily
            }
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                }
                return APIError.jsonParsingError(error)
            }
            .eraseToAnyPublisher()
    }

    func fetchData<T: Decodable>(from endpoint: URL) -> AnyPublisher<T, APIError> {
        return URLSession.shared.dataTaskPublisher(for: endpoint)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                }
                return APIError.jsonParsingError(error)
            }
            .eraseToAnyPublisher()
    }
    
}


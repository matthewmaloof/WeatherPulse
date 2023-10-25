//
//  WeatherAPI.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

enum EndpointType {
    case current
    case daily
    
    var excludeFields: String {
        switch self {
        case .current:
            return ""
        case .daily:
            return "current,minutely,hourly"
        }
    }
}

import Combine
import Foundation

class WeatherAPI: WeatherAPIProtocol {
    
    static let shared = WeatherAPI()
    
    func fetch<T: Decodable>(latitude: Double, longitude: Double, for endpoint: EndpointType, decodingType: T.Type) -> AnyPublisher<T, APIError> {
        let excludeFields = endpoint.excludeFields
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=\(excludeFields)&appid=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.custom("Invalid URL")).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
               if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    throw APIError.invalidStatusCode(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
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


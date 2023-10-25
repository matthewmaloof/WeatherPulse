//
//  WeatherAPIProtocol.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import Combine

protocol WeatherAPIProtocol {
    func fetch<T: Decodable>(latitude: Double, longitude: Double, for endpoint: EndpointType, decodingType: T.Type) -> AnyPublisher<T, APIError>
}

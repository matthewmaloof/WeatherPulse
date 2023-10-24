//
//  WeatherAPIProtocol.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import Combine

protocol WeatherAPIProtocol {
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherModel, APIError>
}

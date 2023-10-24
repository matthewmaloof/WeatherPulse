//
//  WeatherModel.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

struct WeatherModel: Decodable {
    let current: CurrentWeather
    let daily: [DailyWeather]
}

struct CurrentWeather: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
    let wind_speed: Double
    let humidity: Double
    let visibility: Double
    let pressure: Double
    var primaryCondition: String? {
        return weather.first?.main
    }
    let feels_like: Double
}

struct Weather: Decodable, Hashable {
    let main: String
    let icon: String
}

struct DailyWeather: Decodable, Identifiable, Hashable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
    
    var id: Int {
        return dt
    }
}

struct Temp: Decodable, Hashable {
    let min: Double
    let max: Double
}

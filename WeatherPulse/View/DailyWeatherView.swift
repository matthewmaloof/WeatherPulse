//
//  DailyWeatherView.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import SwiftUI

struct DailyWeatherView: View {
    var dailyWeather: DailyWeather
    var viewModel: WeatherViewModel
    
    
    var body: some View {
        HStack {
            Text("\(formattedDate(fromTimestamp: dailyWeather.dt))")
                .font(.system(size: 14)) // Smaller font size
                .bold()
                .foregroundColor(.white)
            
            Spacer()
            
            Text("Min: \(Int(viewModel.kelvinToFahrenheit(dailyWeather.temp.min ?? 0)))°F  Max: \(Int(viewModel.kelvinToFahrenheit(dailyWeather.temp.max ?? 0)))°F")
                .font(.system(size: 14)) // Smaller font size
                .foregroundColor(.white)
                .lineLimit(1)
            
            Spacer()
            
            weatherSymbol(for: dailyWeather.weather.first?.main.lowercased() ?? "")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue.opacity(0.7))
        .cornerRadius(10)
    }
    
    private func weatherSymbol(for condition: String) -> Image {
        switch condition {
        case "clear":
            return Image(systemName: "sun.max.fill")
        case "clouds":
            return Image(systemName: "cloud.fill")
        case "rain":
            return Image(systemName: "cloud.rain.fill")
        case "snow":
            return Image(systemName: "snow")
        case "drizzle":
            return Image(systemName: "cloud.drizzle.fill")
        case "thunderstorm":
            return Image(systemName: "cloud.bolt.fill")
        case "wind":
            return Image(systemName: "wind")
        default:
            return Image(systemName: "questionmark")
        }
    }
    
    // Helper function to format timestamp to date string
    private func formattedDate(fromTimestamp timestamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}


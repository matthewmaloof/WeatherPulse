//
//  DailyWeatherView.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import SwiftUI

struct DailyWeatherView: View {
    var dailyWeather: DailyWeather

    var body: some View {
        HStack {
            Text("\(formattedDate(fromTimestamp: dailyWeather.dt))")
                .bold()
            Spacer()
            Text("\(dailyWeather.temp.min ?? 0.0, specifier: "%.1f")° - \(dailyWeather.temp.max ?? 0.0, specifier: "%.1f")°")
            Image(systemName: dailyWeather.weather.first?.icon ?? "questionmark")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
    
    // Helper function to format timestamp to date string
    private func formattedDate(fromTimestamp timestamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}


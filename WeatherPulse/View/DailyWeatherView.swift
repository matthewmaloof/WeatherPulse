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
            Text("Date Placeholder")
                .bold()
            Spacer()
            Text("\(dailyWeather.temp.min, specifier: "%.1f")° - \(dailyWeather.temp.max, specifier: "%.1f")°")
            Image(systemName: "cloud.fill")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

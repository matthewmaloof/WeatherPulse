//
//  CurrentWeatherView.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import SwiftUI

struct CurrentWeatherView: View {
    var currentWeather: CurrentWeather?
    
    var body: some View {
        VStack {
            Text("\(currentWeather?.temp ?? 0, specifier: "%.1f")°")
                .font(.system(size: 50))
                .bold()
                .transition(.slide)
                .animation(.easeIn(duration: 0.5))
            Text(currentWeather?.weather.first?.main ?? "Unknown")
                .font(.title)
        }
    }
}


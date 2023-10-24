//
//  WeatherPulseView.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import SwiftUI

struct WeatherPulseView: View {
    @ObservedObject var viewModel = WeatherViewModel(api: WeatherAPI(), locationManager: LocationManager())
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    CurrentWeatherView(currentWeather: viewModel.currentWeather)
                    Divider()
                    List(viewModel.dailyWeather ?? [], id: \.self) { weather in
                        DailyWeatherView(dailyWeather: weather)
                    }
                }
            }
            .navigationTitle("WeatherPulse")
            .onAppear {
                viewModel.fetchWeather(latitude: 37.7749, longitude: -122.4194)
            }
        }
        .gesture(DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.height < 0 {
                    self.viewModel.fetchWeather(latitude: 37.7749, longitude: -122.4194)
                }
            }))
    }
}

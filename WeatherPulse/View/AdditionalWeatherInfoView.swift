//
//  AdditionalWeatherInfoView.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/24/23.
//

import Foundation
import SwiftUI

struct AdditionalWeatherInfoView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            // Background
            if let currentWeather = viewModel.currentWeather,
               let condition = currentWeather.primaryCondition?.lowercased() {
                backgroundForCondition(condition)
                    .ignoresSafeArea()
            }
            
            VStack {
                Text("Additional Weather Info")
                    .font(.title)
                    .fontWeight(.bold)
                
                if let currentWeather = viewModel.currentWeather {
                    
                    MetricCard(metricTitle: "Temperature", metricValue: "\(String(format: "%.1f", currentWeather.temp))°C")
                    MetricCard(metricTitle: "Humidity", metricValue: "\(String(format: "%.0f", currentWeather.humidity))%")
                    MetricCard(metricTitle: "Wind Speed", metricValue: "\(String(format: "%.2f", currentWeather.wind_speed)) m/s")
                    MetricCard(metricTitle: "Feels Like", metricValue: "\(String(format: "%.1f", currentWeather.feels_like))°C")
                    MetricCard(metricTitle: "Weather Condition", metricValue: "\(currentWeather.primaryCondition ?? "N/A")")
                    
                    // Dynamic animation based on condition
                    if let condition = currentWeather.primaryCondition?.lowercased() {
                        switch condition {
                        case "rain":
                            RainAnimation()
                        case "wind":
                            WindAnimation()
                        case "clear":
                            SunAnimation()
                        case "clouds":
                            CloudsAnimation()
                        case "mist":
                            MistAnimation()
                        case "drizzle":
                            DrizzleAnimation()
                        case "snow":
                            SnowAnimation()
                        default:
                            Text("No animation available for the condition \(condition).")
                        }
                    }
                } else {
                    Text("Loading...")
                        .onAppear {
                            print("Still loading data...")
                        }
                }
            }
        }
        .id(UUID())
    }
    
    func backgroundForCondition(_ condition: String) -> some View {
        switch condition {
        case "clear":
            return AnyView(LinearGradient(gradient: Gradient(colors: [.yellow, .white]), startPoint: .top, endPoint: .bottom))
        case "clouds":
            return AnyView(LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .top, endPoint: .bottom))
        default:
            return AnyView(Color.white)
        }
    }
}


struct MetricCard: View {
    var metricTitle: String
    var metricValue: String
    
    var body: some View {
        VStack {
            Text(metricValue)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            Text(metricTitle)
                .font(.caption)
                .foregroundColor(Color.gray)
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

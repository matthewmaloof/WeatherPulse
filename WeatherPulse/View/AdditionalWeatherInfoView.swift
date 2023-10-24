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


struct RainAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<100) { _ in
                Circle()
                    .frame(width: CGFloat.random(in: 1...4), height: CGFloat.random(in: 8...12))
                    .foregroundColor(.blue)
                    .offset(x: CGFloat.random(in: 0...geometry.size.width), y: -20)
                    .animation(
                        Animation.linear(duration: 0.7)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...0.5))
                    )
            }
        }
    }
}




struct WindAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<20) { _ in
                Capsule()
                    .frame(width: CGFloat.random(in: 30...60), height: 2)
                    .foregroundColor(.gray)
                    .offset(x: -80, y: CGFloat.random(in: 0...geometry.size.height))
                    .animation(
                        Animation.linear(duration: 2)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...1))
                    )
            }
        }
    }
}




struct SunAnimation: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.yellow)
            ForEach(0..<12) { i in
                Rectangle()
                    .frame(width: 2, height: 20)
                    .foregroundColor(.yellow)
                    .rotationEffect(.degrees(Double(i) * 30))
                    .opacity(0.8)
            }
        }
        .rotationEffect(.degrees(360))
        .animation(Animation.linear(duration: 30).repeatForever(autoreverses: false))
    }
}



struct CloudsAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<10) { _ in
                CloudShape()
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: 100, height: 50)
                    .offset(x: -150, y: CGFloat.random(in: 0...geometry.size.height))
                    .animation(
                        Animation.linear(duration: 5)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...5))
                    )
            }
        }
    }
}


struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: rect.minX, y: rect.minY, width: rect.width / 2, height: rect.height))
        path.addEllipse(in: CGRect(x: rect.minX + rect.width / 4, y: rect.minY - rect.height / 4, width: rect.width / 2, height: rect.height))
        path.addEllipse(in: CGRect(x: rect.minX + rect.width / 2, y: rect.minY, width: rect.width / 2, height: rect.height))
        return path
    }
}

struct DrizzleAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<50) { _ in
                Circle()
                    .frame(width: 1, height: 6)
                    .foregroundColor(.blue)
                    .offset(x: CGFloat.random(in: 0...geometry.size.width), y: -20)
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...1))
                    )
            }
        }
    }
}


struct MistAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<30) { _ in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .offset(x: CGFloat.random(in: 0...geometry.size.width), y: geometry.size.height)
                    .animation(
                        Animation.linear(duration: 3)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...2))
                    )
            }
        }
    }
}

struct SnowAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<100) { _ in
                Circle()
                    .frame(width: 4, height: 4)
                    .foregroundColor(.white)
                    .offset(x: CGFloat.random(in: 0...geometry.size.width), y: -10)
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...1))
                    )
            }
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

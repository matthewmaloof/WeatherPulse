//
//  WeatherPulseView.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import SwiftUI
import Combine
import CoreLocation

struct WeatherPulseView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var selectedCity: String = "San Francisco"
    @State private var showAdditionalInfo: Bool = false
    @State private var isLocationPermissionGranted = false
    @State private var dailyWeather: [DailyWeather] = [] // Add this state
    
    
    // Create an instance of CLLocationManager
    let locationManager = CLLocationManager()
    
    // Dynamic background based on weather condition
    private func weatherBackground(_ condition: String) -> some View {
        switch condition {
        case "rain":
            return AnyView(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray]), startPoint: .top, endPoint: .bottom))
        case "clear":
            return AnyView(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.yellow]), startPoint: .top, endPoint: .bottom))
        default:
            return AnyView(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.white]), startPoint: .top, endPoint: .bottom))
        }
    }
    
    init() {
        // Initialize the view model with the locationManager
        self.viewModel = WeatherViewModel(api: WeatherAPI(), locationManager: locationManager)
        setupLocationManager()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient based on weather condition
                if let condition = viewModel.currentWeather?.weather.first?.main.lowercased() {
                    weatherBackground(condition)
                        .ignoresSafeArea()
                }
                VStack {
                    Text("Weather Pulse")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                    
                    // City selection picker
                    Picker("Select city", selection: $selectedCity) {
                        ForEach(viewModel.cities, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: selectedCity) { newValue in
                        let coordinates = cityCoordinates(for: newValue)
                        viewModel.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                        
                        // Fetch daily weather when the city changes
                        viewModel.fetchDailyWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                        
                        showAdditionalInfo = true
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(20)
                    
                    Button("Show Additional Weather Info") {
                        showAdditionalInfo.toggle()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .scaleEffect(showAdditionalInfo ? 1.1 : 1.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1))
                    )
                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                    .sheet(isPresented: $showAdditionalInfo) {
                        AdditionalWeatherInfoView(viewModel: viewModel)
                    }
                    
                    // Current weather view
                    if let currentWeather = viewModel.currentWeather {
                        CurrentWeatherView(currentWeather: currentWeather)
                            .padding()
                    } else {
                        Text("Loading current weather...")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    // Daily weather list
                    if let dailyWeather = viewModel.dailyWeather, !dailyWeather.isEmpty {
                        List(dailyWeather, id: \.id) { day in
                            DailyWeatherView(dailyWeather: day, viewModel: viewModel)
                                .listRowBackground(Color.clear) // Make the row background transparent
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear) // Make the list background transparent
                    } else {
                        Text("No daily weather data available.")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            .onAppear {
                setupLocationManager()
            }
        }
        
    }
    
    func cityCoordinates(for city: String) -> (latitude: Double, longitude: Double) {
        switch city {
        case "San Francisco":
            return (37.7749, -122.4194)
        case "New York":
            return (40.7128, -74.0060)
        case "Chicago":
            return (41.8781, -87.6298)
        case "Los Angeles":
            return (34.0522, -118.2437)
        case "Miami":
            return (25.7617, -80.1918)
        case "Houston":
            return (29.7604, -95.3698)
        case "Boston":
            return (42.3601, -71.0589)
        case "Denver":
            return (39.7392, -104.9903)
        case "Seattle":
            return (47.6062, -122.3321)
        case "Atlanta":
            return (33.7490, -84.3880)
        case "Nashville":
            return (36.1627, -86.7816)
        case "Las Vegas":
            return (36.1699, -115.1398)
        case "Portland":
            return (45.5122, -122.6587)
        case "Philadelphia":
            return (39.9526, -75.1652)
        case "Orlando":
            return (28.5383, -81.3792)
        case "Dallas":
            return (32.7767, -96.7970)
        case "Phoenix":
            return (33.4484, -112.0740)
        case "Austin":
            return (30.2672, -97.7431)
        case "San Diego":
            return (32.7157, -117.1611)
        case "Indianapolis":
            return (39.7684, -86.1581)
        case "Columbus":
            return (39.9612, -82.9988)
        case "San Antonio":
            return (29.4241, -98.4936)
        case "Jacksonville":
            return (30.3322, -81.6557)
        case "Charlotte":
            return (35.2271, -80.8431)
        case "Detroit":
            return (42.3314, -83.0458)
        default:
            return (0, 0)
        }
    }
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            isLocationPermissionGranted = true
        } else {
            selectedCity = "San Francisco"
            
            // Fetch daily weather for the default city
            let coordinates = cityCoordinates(for: selectedCity)
            viewModel.fetchDailyWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
        }
    }
}



extension Publisher {
    func onChange(perform action: @escaping (Output) -> Void) -> Publishers.HandleEvents<Self> {
        self.handleEvents(receiveOutput: action)
    }
}



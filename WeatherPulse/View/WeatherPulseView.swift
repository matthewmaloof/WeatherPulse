//
//  WeatherPulseView.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import SwiftUI
import Combine
import CoreLocation

struct CityWithCoordinates: Identifiable {
    var id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}


struct WeatherPulseView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var selectedCity: String = "San Francisco"
    @State private var isLocationPermissionGranted = false
    @State private var dailyWeather: [DailyWeather] = []
    @State private var searchText: String = ""
    @State private var showCitySearch = false
    
    private let allCities: [String] = ["San Francisco", "New York", "Chicago", "Los Angeles", "Miami",
                                       "Houston", "Boston", "Denver", "Seattle", "Atlanta",
                                       "Nashville", "Las Vegas", "Portland", "Philadelphia", "Orlando",
                                       "Dallas", "Phoenix", "Austin", "San Diego", "Indianapolis",
                                       "Columbus", "San Antonio", "Jacksonville", "Charlotte", "Detroit"]
    
    private let allCitiesWithCoordinates: [CityWithCoordinates] = [
        CityWithCoordinates(name: "San Francisco", latitude: 37.7749, longitude: -122.4194),
        CityWithCoordinates(name: "New York", latitude: 40.7128, longitude: -74.0060),
        CityWithCoordinates(name: "Chicago", latitude: 41.8781, longitude: -87.6298),
        CityWithCoordinates(name: "Los Angeles", latitude: 34.0522, longitude: -118.2437),
        CityWithCoordinates(name: "Miami", latitude: 25.7617, longitude: -80.1918),
        CityWithCoordinates(name: "Houston", latitude: 29.7604, longitude: -95.3698),
        CityWithCoordinates(name: "Boston", latitude: 42.3601, longitude: -71.0589),
        CityWithCoordinates(name: "Denver", latitude: 39.7392, longitude: -104.9903),
        CityWithCoordinates(name: "Seattle", latitude: 47.6062, longitude: -122.3321),
        CityWithCoordinates(name: "Atlanta", latitude: 33.7490, longitude: -84.3880),
        CityWithCoordinates(name: "Nashville", latitude: 36.1627, longitude: -86.7816),
        CityWithCoordinates(name: "Las Vegas", latitude: 36.1699, longitude: -115.1398),
        CityWithCoordinates(name: "Portland", latitude: 45.5122, longitude: -122.6587),
        CityWithCoordinates(name: "Philadelphia", latitude: 39.9526, longitude: -75.1652),
        CityWithCoordinates(name: "Orlando", latitude: 28.5383, longitude: -81.3792),
        CityWithCoordinates(name: "Dallas", latitude: 32.7767, longitude: -96.7970),
        CityWithCoordinates(name: "Phoenix", latitude: 33.4484, longitude: -112.0740),
        CityWithCoordinates(name: "Austin", latitude: 30.2672, longitude: -97.7431),
        CityWithCoordinates(name: "San Diego", latitude: 32.7157, longitude: -117.1611),
        CityWithCoordinates(name: "Indianapolis", latitude: 39.7684, longitude: -86.1581),
        CityWithCoordinates(name: "Columbus", latitude: 39.9612, longitude: -82.9988),
        CityWithCoordinates(name: "San Antonio", latitude: 29.4241, longitude: -98.4936),
        CityWithCoordinates(name: "Jacksonville", latitude: 30.3322, longitude: -81.6557),
        CityWithCoordinates(name: "Charlotte", latitude: 35.2271, longitude: -80.8431),
        CityWithCoordinates(name: "Detroit", latitude: 42.3314, longitude: -83.0458),
    ]
    
    
    let locationManager = CLLocationManager()
    
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
        self.viewModel = WeatherViewModel(api: WeatherAPI(), locationManager: locationManager)
        setupLocationManager()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if let condition = viewModel.currentWeather?.weather.first?.main.lowercased() {
                    weatherBackground(condition)
                        .ignoresSafeArea()
                        .zIndex(0) // Set the background to the lowest layer
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        WeatherPulseLogo()
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        Button(action: {
                            showCitySearch.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.trailing, 10)
                        }
                        .sheet(isPresented: $showCitySearch) {
                            CitySearchView(
                                searchText: $searchText,
                                cities: allCities,
                                didSelectCity: { newCity in
                                    selectedCity = newCity
                                    let coordinates = cityCoordinates(for: selectedCity)
                                    viewModel.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                                    viewModel.fetchDailyWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                                },
                                selectedCity: $selectedCity,
                                showCitySearch: $showCitySearch
                            )
                        }
                        
                        
                        
                        
                        
                        Button(action: {
                            let coordinates = cityCoordinates(for: selectedCity)
                            viewModel.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                            viewModel.fetchDailyWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                        }) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.trailing, 10)
                        }
                    }
                    
                    if let currentWeather = viewModel.currentWeather {
                        VStack(alignment: .center) {
                            Text(selectedCity)
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                            SearchBar(text: $searchText)
                                .padding(.horizontal, 10)
                            
                            if !searchText.isEmpty {
                                List(allCitiesWithCoordinates.filter {
                                    $0.name.lowercased().contains(searchText.lowercased())
                                }) { city in
                                    Text(city.name)
                                        .onTapGesture {
                                            selectedCity = city.name // Update the selected city
                                            searchText = "" // Clear the search text
                                            viewModel.fetchWeather(latitude: city.latitude, longitude: city.longitude)
                                            viewModel.fetchDailyWeather(latitude: city.latitude, longitude: city.longitude)
                                            showCitySearch = false // Close the dropdown
                                        }
                                }
                                .listStyle(PlainListStyle())
                                .background(Color.clear)
                                .zIndex(2) // Set the list to the highest layer
                            }
                            weatherSymbol(for: currentWeather.weather.first?.main.lowercased() ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            
                            Text("\(String(format: "%.1f°F", viewModel.kelvinToFahrenheit(currentWeather.temp)))")
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Center-align the VStack
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                        .zIndex(2) // Set the list to the highest layer
                    } else {
                        Text("Loading temperature...")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.bottom, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    if let currentWeather = viewModel.currentWeather {
                        HStack {
                            MetricCard(metricTitle: "Temp", metricValue: "\(String(format: "%.1f°F", viewModel.kelvinToFahrenheit(currentWeather.temp)))")
                            MetricCard(metricTitle: "Humidity", metricValue: "\(String(format: "%.0f%", currentWeather.humidity))")
                            MetricCard(metricTitle: "Wind", metricValue: "\(String(format: "%.2f m/s", currentWeather.wind_speed))")
                            MetricCard(metricTitle: "Feels Like", metricValue: "\(String(format: "%.1f°F", viewModel.kelvinToFahrenheit(currentWeather.feels_like)))")
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text("Loading additional weather info...")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    if let dailyWeather = viewModel.dailyWeather, !dailyWeather.isEmpty {
                        List(dailyWeather, id: \.id) { day in
                            DailyWeatherView(dailyWeather: day, viewModel: viewModel)
                                .listRowBackground(Color.clear)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    } else {
                        Text("No daily weather data available.")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            .onAppear {
                let coordinates = cityCoordinates(for: selectedCity)
                viewModel.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                viewModel.fetchDailyWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
        }
    }
    
    func cityCoordinates(for city: String) -> (latitude: Double, longitude: Double) {
        if let cityInfo = allCitiesWithCoordinates.first(where: { $0.name == city }) {
            return (cityInfo.latitude, cityInfo.longitude)
        } else {
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
    
    func weatherSymbol(for condition: String) -> Image {
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
}



extension Publisher {
    func onChange(perform action: @escaping (Output) -> Void) -> Publishers.HandleEvents<Self> {
        self.handleEvents(receiveOutput: action)
    }
}


struct WeatherPulseLogo: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10) // Create a rounded rectangle background
                .fill(Color.blue)
                .frame(width: 80, height: 40) // Adjust size
            
            Text("WP")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

struct MetricCard: View {
    var metricTitle: String
    var metricValue: String
    
    var body: some View {
        VStack {
            Text(metricValue)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            Text(metricTitle)
                .font(.subheadline)
                .foregroundColor(Color.gray)
        }
        .padding(10)
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

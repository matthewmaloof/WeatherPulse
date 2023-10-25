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
    @State private var allCities: [String]
    
    
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
        self.allCities = Constants.allCities
        
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
                                    
                                    // Using the generic fetchWeatherData function for fetching current weather
                                    viewModel.fetchWeatherData(
                                        latitude: coordinates.latitude,
                                        longitude: coordinates.longitude,
                                        endpointType: .current,
                                        decodingType: WeatherModel.self
                                    )
                                    
                                    // Using the generic fetchWeatherData function for fetching daily weather
                                    viewModel.fetchWeatherData(
                                        latitude: coordinates.latitude,
                                        longitude: coordinates.longitude,
                                        endpointType: .daily,
                                        decodingType: [DailyWeather].self
                                    )
                                },
                                selectedCity: $selectedCity,
                                showCitySearch: $showCitySearch
                            )
                        }
                        
                        
                        
                        
                        
                        Button(action: {
                            let coordinates = cityCoordinates(for: selectedCity)
                            // Using the generic fetchWeatherData function for fetching current weather
                            viewModel.fetchWeatherData(
                                latitude: coordinates.latitude,
                                longitude: coordinates.longitude,
                                endpointType: .current,
                                decodingType: WeatherModel.self
                            )
                            
                            // Using the generic fetchWeatherData function for fetching daily weather
                            viewModel.fetchWeatherData(
                                latitude: coordinates.latitude,
                                longitude: coordinates.longitude,
                                endpointType: .daily,
                                decodingType: [DailyWeather].self
                            )
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
                                List(Constants.allCitiesWithCoordinates.filter {
                                    $0.name.lowercased().contains(searchText.lowercased())
                                }) { city in
                                    Text(city.name)
                                        .onTapGesture {
                                            selectedCity = city.name // Update the selected city
                                            searchText = "" // Clear the search text
                                            let coordinates = cityCoordinates(for: selectedCity)
                                            
                                            // Using the generic fetchWeatherData function for fetching current weather
                                            viewModel.fetchWeatherData(
                                                latitude: coordinates.latitude,
                                                longitude: coordinates.longitude,
                                                endpointType: .current,
                                                decodingType: WeatherModel.self
                                            )
                                            
                                            // Using the generic fetchWeatherData function for fetching daily weather
                                            viewModel.fetchWeatherData(
                                                latitude: coordinates.latitude,
                                                longitude: coordinates.longitude,
                                                endpointType: .daily,
                                                decodingType: [DailyWeather].self
                                            )
                                            showCitySearch = false // Close the dropdown
                                        }
                                }
                                .frame(height: 100)
                                .listStyle(PlainListStyle())
                                .background(Color.clear)
                                .zIndex(2) // Set the list to the highest layer
                            }
                            weatherSymbol(for: currentWeather.weather.first?.main.lowercased() ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            
                            Text("\(String(format: "%.1f°F", currentWeather.temp.kelvinToFahrenheit()))")
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
                            MetricCard(metricTitle: "Temp", metricValue: "\(String(format: "%.1f°F", currentWeather.temp.kelvinToFahrenheit()))")
                            MetricCard(metricTitle: "Humidity", metricValue: "\(String(format: "%.0f%", currentWeather.humidity))")
                            MetricCard(metricTitle: "Wind", metricValue: "\(String(format: "%.2f m/s", currentWeather.wind_speed))")
                            MetricCard(metricTitle: "Feels Like", metricValue: "\(String(format: "%.1f°F", currentWeather.feels_like.kelvinToFahrenheit()))")
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
                
                // Using the generic fetchWeatherData function for fetching current weather
                viewModel.fetchWeatherData(
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                    endpointType: .current,
                    decodingType: WeatherModel.self
                )
                
                // Using the generic fetchWeatherData function for fetching daily weather
                viewModel.fetchWeatherData(
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                    endpointType: .daily,
                    decodingType: [DailyWeather].self
                )
            }
        }
    }
    
    func cityCoordinates(for city: String) -> (latitude: Double, longitude: Double) {
        if let cityInfo = Constants.allCitiesWithCoordinates.first(where: { $0.name == city }) {
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
            // Using the generic fetchWeatherData function for fetching daily weather
            viewModel.fetchWeatherData(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                endpointType: .daily,
                decodingType: [DailyWeather].self
            )
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

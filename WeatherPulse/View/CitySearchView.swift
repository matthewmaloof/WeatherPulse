//
//  CitySearchView.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/24/23.
//

import SwiftUI

struct City: Identifiable {
    var id = UUID()
    var name: String
    
    init(name: String) {
        self.name = name
    }
}


// Create a custom SearchBar view
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search City", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct CitySearchView: View {
    @Binding var searchText: String
    var cities: [String] // This should be an array of strings
    var didSelectCity: (String) -> Void
    @Binding var selectedCity: String // Add a binding for the selected city
    @Binding var showCitySearch: Bool // Binding to control the sheet presentation
    var filteredCities: [String] {
            if searchText.isEmpty {
                return cities
            } else {
                return cities.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        }
    var body: some View {
        NavigationView {
            List {
                Section(header:
                    TextField("Search City", text: $searchText) // Search bar
                ) {
                    ForEach(filteredCities, id: \.self) { city in
                        Button(action: {
                            selectedCity = city // Update the selected city
                            searchText = "" // Clear the search text
                            didSelectCity(city)
                            showCitySearch = false // Close the list screen
                        }) {
                            Text(city)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Select a City")
            .navigationBarItems(trailing: Button("Close") {
                showCitySearch = false // Close the list screen
            })
        }
    }
}

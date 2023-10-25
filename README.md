# WeatherPulse

![Platform](https://img.shields.io/badge/platform-iOS-blue)
![Language](https://img.shields.io/badge/language-Swift-orange)
![SwiftUI](https://img.shields.io/badge/framework-SwiftUI-brightgreen)

## Table of Contents
1. [Overview](#overview)
2. [Preview](#preview)
3. [Features](#features)
4. [Installation](#installation)
5. [Requirements](#requirements)
6. [Usage](#usage)
7. [API Integration](#api-integration)
8. [Testing](#testing)
9. [Contributions](#contributions)

## Overview

WeatherPulse is a weather forecast app developed in Swift using SwiftUI. The app provides real-time weather updates and forecasts by fetching data from a REST API. It features an interactive and visually pleasing user interface designed to enhance user experience.

## Preview

https://github.com/matthewmaloof/WeatherPulse/assets/148370987/4354c631-fa00-4923-8624-14c04bcdc3c6

## Features

### UI Design

- **Current Weather Conditions**: Displays the current temperature, weather description, and an icon representing the weather.
- **Daily Forecast**: Includes a section that shows the weather forecast for the next 5 days with date, weather icon, and temperature range.

### Networking

- Uses a REST API for fetching current weather conditions and a 5-day forecast.
- Implements error-handling techniques for network requests.

### Data Parsing

- Parses JSON responses into Swift models.
- Utilizes Swift data structures for efficient data storage and retrieval.

### User Experience

- Smooth transitions and animations.
- Loading indicators during data fetch.

### Bonus

- **Search Functionality**: Allows users to search for weather in different locations.
- **Unit Tests**: Includes unit tests for networking and data parsing.

## Installation

To get the project up and running, you'll need to:

1. Clone the repository: 
    ```sh
    git clone https://github.com/matthewmaloof/WeatherPulse.git
    ```
2. Open `WeatherPulse.xcodeproj` in Xcode.
3. Build and run the project on the desired simulator or real device.

## Requirements

- iOS 15.0+
- Swift 5.5+
- Xcode 13.0+

## Usage

To fetch weather data, you will need to input the latitude and longitude of the location you're interested in. You can also use the search functionality to find weather information for different locations.

## API Integration

This project uses [OpenWeatherMap API](https://openweathermap.org/api) to fetch weather data. To use this API, you'll need to obtain an API key and insert it into the `APIManager.swift` file. In this project it is hardcoded.

## Testing

The project includes unit tests for API calls and data parsing logic. Run the tests using the `Cmd+U` shortcut in Xcode.

## Contributions

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

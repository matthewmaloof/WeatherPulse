//
//  WeatherAPIError.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/23/23.
//

import Foundation

enum APIError: Error {
    case network(description: String)
    case networkError(Error)       // Indicates a networking error
    case dataNotFound              // No data returned
    case jsonParsingError(Error)   // Error parsing JSON
    case invalidStatusCode(Int)    // HTTP status code indicates failure
    case custom(String)            // Custom error
    case locationError(Error)
    
    var localizedDescription: String {
        switch self {
        case .network(let description):
            return NSLocalizedString(description, comment: "Network error")
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .dataNotFound:
            return "Error: Data not found"
        case .jsonParsingError(let error):
            return "JSON Parsing Error: \(error.localizedDescription)"
        case .invalidStatusCode(let code):
            return "Invalid Status Code: \(code)"
        case .custom(let message):
            return message
        case .locationError(let error):
            return "Location Error: \(error)"
        }
    }
}

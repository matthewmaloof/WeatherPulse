//
//  MetricCardView.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/25/23.
//

import Foundation
import SwiftUI

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

//
//  SunAnimation.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/24/23.
//

import SwiftUI
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

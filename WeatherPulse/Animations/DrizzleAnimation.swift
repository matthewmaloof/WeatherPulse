//
//  DrizzleAnimation.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/24/23.
//

import SwiftUI

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

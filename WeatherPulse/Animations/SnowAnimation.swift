//
//  SnowAnimation.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/24/23.
//

import SwiftUI

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

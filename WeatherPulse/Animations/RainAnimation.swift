//
//  RainAnimation.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/24/23.
//

import Foundation
import SwiftUI

struct RainAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<100) { _ in
                Circle()
                    .frame(width: CGFloat.random(in: 1...4), height: CGFloat.random(in: 8...12))
                    .foregroundColor(.blue)
                    .offset(x: CGFloat.random(in: 0...geometry.size.width), y: -20)
                    .animation(
                        Animation.linear(duration: 0.7)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...0.5))
                    )
            }
        }
    }
}

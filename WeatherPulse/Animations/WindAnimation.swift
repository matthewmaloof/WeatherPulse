//
//  WindAnimation.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/24/23.
//

import SwiftUI
struct WindAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<20) { _ in
                Capsule()
                    .frame(width: CGFloat.random(in: 30...60), height: 2)
                    .foregroundColor(.gray)
                    .offset(x: -80, y: CGFloat.random(in: 0...geometry.size.height))
                    .animation(
                        Animation.linear(duration: 2)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...1))
                    )
            }
        }
    }
}

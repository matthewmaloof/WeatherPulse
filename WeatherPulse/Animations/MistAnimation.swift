//
//  MistAnimation.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/24/23.
//

import SwiftUI

struct MistAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<30) { _ in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .offset(x: CGFloat.random(in: 0...geometry.size.width), y: geometry.size.height)
                    .animation(
                        Animation.linear(duration: 3)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...2))
                    )
            }
        }
    }
}


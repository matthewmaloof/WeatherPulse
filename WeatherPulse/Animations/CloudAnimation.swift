//
//  CloudAnimation.swift
//  WeatherPulse
//
//  Created by Matthew Maloof on 10/24/23.
//

import SwiftUI

struct CloudsAnimation: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<10) { _ in
                CloudShape()
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: 100, height: 50)
                    .offset(x: -150, y: CGFloat.random(in: 0...geometry.size.height))
                    .animation(
                        Animation.linear(duration: 5)
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...5))
                    )
            }
        }
    }
}

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: rect.minX, y: rect.minY, width: rect.width / 2, height: rect.height))
        path.addEllipse(in: CGRect(x: rect.minX + rect.width / 4, y: rect.minY - rect.height / 4, width: rect.width / 2, height: rect.height))
        path.addEllipse(in: CGRect(x: rect.minX + rect.width / 2, y: rect.minY, width: rect.width / 2, height: rect.height))
        return path
    }
}

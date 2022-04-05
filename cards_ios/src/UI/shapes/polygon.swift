//
//  polygon.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/8/22.
//

import SwiftUI

struct Polygon: Shape {
    let sides:Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let diameter: Double = Double(rect.width)
        let radius:Double = diameter / 2
        
        path.move(to: CGPoint(x: diameter, y: radius))
        
        for angle in stride(from: 0, to: 360, by: 360/sides) {
            let radian = Double(angle) * Double.pi / 180.0

            let x = radius * (1+cos(radian))
            let y = radius * (1+sin(radian))
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.closeSubpath()
        return path
    }
}

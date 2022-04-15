//
//  triangle.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 4/5/22.
//

import SwiftUI

struct Triangle: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 0))

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        Triangle().frame(width: 100 * sqrt(3), height: 200)
    }
}

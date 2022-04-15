//
//  SLTriangleModel.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 4/13/22.
//

import SwiftUI

class SLTriangleModel{
    enum TriangleHalf { case upper, lower }
    let triangleHalf: (Float) -> TriangleHalf = {($0 > 0.5) ? .upper : .lower}
    var height: CGFloat
    var width: CGFloat
    
    init(height: CGFloat, width: CGFloat?) {
        self.height = height
        self.width = width ?? (height * sqrt(3)/2)
    }
    
    let upperLinearEquation = makeLinearEquation(m: -0.5, c: 1)
    let lowerLinearEquation = makeLinearEquation(m: 0.5, c: 0)
    
    let leadingLinearEquation = makeLinearEquation(m: 2, c: 0)
    let trailingLinearEquation = makeLinearEquation(m: -2, c: 2)
    
    func borderYForX(_ x: Float, inHalf: TriangleHalf) -> Float{
        switch inHalf {
        case .upper:
            return upperLinearEquation(x)
        case .lower:
            return lowerLinearEquation(x)
        }
    }
    func borderXForY(_ y: Float, inHalf: TriangleHalf) -> Float{
        switch inHalf {
        case .upper:
            return leadingLinearEquation(y)
        case .lower:
            return trailingLinearEquation(y)
        }
    }
    func getPositionFromColor(s: Float, l: Float) -> CGPoint {
        // Here we are switching x and y axis 
        let m: Float = 2
        let g_l: Float = {
            if l < 0.5 {
                return m * l
            } else if l > 0.5 {
                return 2 - (m * l)
            } else {
                return 1
            }
        }()
        let f_sl: Float = s * g_l
        return UnitPoint(x: CGFloat(f_sl), y: CGFloat(l)).toCGPoint(width, height)
    }
    
    func getColorFromRelativeDragPosition(x: Float, y: Float) -> (s: Float, l: Float) {
        let positionInXRange: Bool = (0 < x) && (x < 1)
        if !positionInXRange{
            let res:(s: Float, l: Float) = (x <= 0) ? (s: 0, l: y.inRange(max: 1)) : (s: 1, l: 0.5)
            return res
        }
        let half = triangleHalf(y)
        let border = borderYForX(x, inHalf: half)
        // if Position in Triangle --> go ahead
        let positionInYRange: Bool = (half == .upper) ? (y < border) : (y > border)
        
        if positionInYRange {
            let light = y
            let sat = x / borderXForY(y, inHalf: half)
            return (s: sat, l: light)
        } else {
            // else --> snap to margins
            let result: (s: Float, l: Float) = (s: 1, l: border)
            return result
        }
    }
    
    func getColorFromPositionInTriangle(x: Float, y: Float, half: TriangleHalf? = nil) -> (s: Float, l: Float) {
        let half = half ?? triangleHalf(y)
        let light = y
        let sat = x / borderXForY(y, inHalf: half)
        return (s: sat, l: light)
    }
}



/*
// lightness --> saturation

// !!! IMPORTANT !!!
// switched width / height to match coordinate system
let relativeDrag = (dx: (value.translation.height / triangleFrame.height), dy: (value.translation.width / triangleFrame.width))

let relX = (preDrag.lightness + relativeDrag.dx).inRange(max: 1)
let relY = (preDrag.saturation + relativeDrag.dy).inRange(max: 1)

if relY == 1 {
    color.saturation = 1
    color.lightness = 0.5
    return
}
// m = 2       y != relY       x = l
// y = ml      y = m - ml

// x1 = y/m             =>      y / 2
// x2 = (m - y) / m     => 1 - (y / 2)
let _x1 = relY / 2
let border = (x1: _x1, x2: 1 - _x1)


if border.x1...border.x2 ~= relX {
    if relY == 0 {
        color.saturation = 0
        color.lightness = Float(relX)
    } else{
        let res = getSatAndLightFromPoint(relX: Float(relX), relY: Float(relY))
        color.saturation = res.sat
        color.lightness = res.light
    }
} else if relX < border.x1{
    color.saturation = 1
    color.lightness = Float(border.x1)
} else if relX > border.x2{
    color.saturation = 1
    color.lightness = Float(border.x2)
}
*/

//
//  core_graphics.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/8/22.
//
import CoreGraphics

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}

extension Float{
    func inRange(min: Float = 0, max: Float) -> Float {
        if (min < self) && (self < max) { return self }
        else if (self < min) { return min }
        return max
    }
    func percent() -> Int {
        return Int(ceil(self*100))
    }
}
extension CGFloat{
    func inRange(min: CGFloat = 0, max: CGFloat) -> CGFloat {
        if (min < self) && (self < max) { return self }
        else if (self < min) { return min }
        return max
    }
    func degreeToRadian() -> CGFloat {
        return (self * CGFloat.pi) / 180
    }
    func percent() -> Int {
        return Int(self*100)
    }
}

//
//  core_graphics.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/8/22.
//
import CoreGraphics






func getPitch(point1: CGPoint, point2: CGPoint) -> CGFloat {
    return (point2.y - point1.y)/(point2.x - point1.x)
}

func makeLinearEquation(m: Float, c: Float) -> ((Float) -> Float) {
    func linearEquation(x: Float) -> Float{
        return m * x + c
    }
    return linearEquation
}

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

infix operator **
func ** (num: Double, power: Double) -> Double{
    return pow(num, power)
}

prefix operator √
prefix func √(rhs: Double) -> Double {
return sqrt(rhs)
}

infix operator +-
func +-(lhs: Float, rhs: Float) -> (min: Float, max: Float) {
    return (min: lhs-rhs, max: lhs+rhs)
}
func +-(lhs: CGFloat, rhs: CGFloat) -> (min: CGFloat, max: CGFloat) {
    return (min: lhs-rhs, max: lhs+rhs)
}

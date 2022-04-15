//
//  core_graphics.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/8/22.
//
import CoreGraphics

infix operator **
prefix operator √ // option + v
infix operator ± // option + [+]

extension FloatingPoint{
    static func **(base: Self, exponent: Int) -> Self {
        return Array(repeating: base, count: exponent).reduce(1, *)
    }
    static prefix func √(root: Self) -> Self {
        return sqrt(root)
    }
    static func ±(lhs: Self, rhs: Self) -> (lower: Self, higher: Self){
        return (lower: lhs - rhs, higher: lhs + rhs)
    }
    func inRange(min: Self = 0, max: Self) -> Self {
        if (min < self) && (self < max) { return self }
        else if (self < min) { return min}
        return max
    }
}
extension BinaryFloatingPoint{
    var percent: Int {
        return Int(ceil(self * 100))
    }
}
extension Int: Sequence{
    public func makeIterator() -> some IteratorProtocol {
        return (0..<self).makeIterator()
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}


// MARK: - Global Functions

func getPitch(x1: Float, x2: Float, y1: Float, y2: Float) -> Float {
    return (y2 - y1)/(x2 - x1)
}

func makeLinearEquation(m: Float, c: Float) -> ((Float) -> Float) {
    func linearEquation(x: Float) -> Float{
        return m * x + c
    }
    return linearEquation
}

func getXForY(y: Float, m: Float, c: Float) -> Float {
    return (y-c) / m
}

func degreesToRadian<T: FloatingPoint>(_ degrees: T) -> some FloatingPoint {
    let pi: T = 3.141592653589793 as! T
    return (degrees * pi) / 180
}

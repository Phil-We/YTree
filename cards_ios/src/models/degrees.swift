//
//  degrees.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 4/15/22.
//

import Foundation

struct Degrees: Equatable{
    private var wrappedValue: Float = 0
    var degrees: Float {
        get {wrappedValue}
        set {setDegrees(newValue)}
    }
    var radian: Float {
        let pi: Float = 3.141592653589793
        return (wrappedValue * pi) / 180
    }
    var sin: Float {return sinf(radian)}
    var cos: Float {return cosf(radian)}
    
    init(_ value: Float) {
        setDegrees(value)
    }
    private mutating func setDegrees(_ newValue: Float) {
        if (0 <= newValue) && (newValue < 360){
            wrappedValue = newValue
            return
        }
        let newValue = (abs(newValue) < 360) ? newValue : remainder(newValue, 360)
        if newValue >= 0 { wrappedValue = newValue}
        else { wrappedValue = 360 + newValue}
    }
}

extension Degrees: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral{
    init(floatLiteral value: FloatLiteralType) {
        self.init(Float(value))
    }
    init(integerLiteral value: IntegerLiteralType) {
        self.init(Float(value))
    }
}

extension Degrees: CustomStringConvertible{
    var description: String{
        return "\(wrappedValue)°"
    }
}

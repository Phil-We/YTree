//
//  color.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/8/22.
//https://en.wikipedia.org/wiki/HSL_and_HSV#Interconversion

import SwiftUI
import Combine

// MARK: HSLV
struct HSLV: Equatable{
    var h: Degrees
    var s_l: Float
    var l: Float
    
    var s_v: Float{
        if v == 0 {
            return 0
        } else {
            return 2 * (1-l/v)
        }
    }
    var v: Float{
        return l + (s_l * min(l, 1-l))
    }
    
    init(h: Float, s: Float, l: Float) {
        self.h = Degrees(h)
        self.s_l = s.inRange(max: 1)
        self.l = l.inRange(max: 1)
    }
    
    func toRGB() -> RGB {
        let C = (1-abs(2*l-1))*s_l
        let H = h.degrees/60
        let X = abs(C*(1-abs(remainder(H, 2)-1)))
        let m = l - C/2
        
        var _rgb: RGB = {
            if (0<=H) && (H<1) {
                return RGB(r: C, g: X, b: 0)
            } else if (1<=H) && (H<2) {
                return RGB(r: X, g: C, b: 0)
            } else if (2<=H) && (H<3) {
                return RGB(r: 0, g: C, b: X)
            } else if (3<=H) && (H<4) {
                return RGB(r: 0, g: X, b: C)
            } else if (4<=H) && (H<5) {
                return RGB(r: X, g: 0, b: C)
            } else if (5<=H) && (H<6) {
                return RGB(r: C, g: 0, b: X)
            }
            return RGB(r: 0, g: 0, b: 0)
        }()
        
        _rgb.r += m
        _rgb.g += m
        _rgb.b += m
        
        return _rgb
    }
    
    func toColor() -> Color {
        return Color(hue: CGFloat(h.degrees / 360), saturation: CGFloat(s_v), brightness: CGFloat(v), opacity: 1)
    }
}

// MARK: RGB
// -parameters: all in range 0...1
struct RGB: Equatable {
    var r: Float // [0 ; 1]
    var g: Float // [0 ; 1]
    var b: Float // [0 ; 1]
    
    init(r: Float, g: Float, b: Float) {
        assert(0...1 ~= r, "Invalid red value /Color/RGB/init")
        assert(0...1 ~= g, "Invalid green value /Color/RGB/init")
        assert(0...1 ~= b, "Invalid blue value /Color/RGB/init")
        
        self.r = r
        self.g = g
        self.b = b
    }
    
    func toHSLV() -> HSLV {
        let M = min(r, g, b)
        let m = max(r, g, b)
        
        let C = M - m
        let V = M
        let L = (M + m) / 2 // V - (C/2)
        
        let H: Float = {
            if (C == 0) {
                return 0
            } else if (V == r) {
                return 60 * remainderf( (g-b) / C, 6 ) + 180
            } else if (V == g) {
                return 60 * ((b-r) / C + 2) + 180
            } else if (V == b){
                return 60 * ((r-g) / C + 4) + 180
            }
            return 0
        }()
        
        let S_l: Float = {
            if C != 0{
                return abs(C / (1 - abs(2*L-1)))
            } else { return 0}
        }()
        
        return HSLV(h: H, s: S_l, l: L)
    }
}

// MARK: CUSTOM Color
class CustomColor: ObservableObject, Identifiable, Equatable {
        
    static func == (lhs: CustomColor, rhs: CustomColor) -> Bool {
        return lhs._rgb == rhs._rgb
       // return false
    }
    
    var id = UUID()
    
    @Published var alpha: Float = 1
    
    private var _rgb: RGB
    private var _hsl: HSLV
    
    var red: Float{
        get{ _rgb.r }
        set{
            assert(0...1 ~= newValue, "Value out of range")
            _rgb.r = newValue
            _hsl = _rgb.toHSLV()
            objectWillChange.send()
        }
    }
    var green: Float{
        get{ _rgb.g }
        set{
            assert(0...1 ~= newValue, "Value out of range")
            _rgb.g = newValue
            _hsl = _rgb.toHSLV()
            objectWillChange.send()
        }
    }
    var blue: Float{
        get{ _rgb.b }
        set{
            assert(0...1 ~= newValue, "Value out of range")
            _rgb.b = newValue
            _hsl = _rgb.toHSLV()
            objectWillChange.send()
        }
    }
    
    var hue: Float{
        get{ _hsl.h.degrees }
        set{
            //assert(0...360 ~= newValue, "Value out of range")
            _hsl.h.degrees = newValue
            _rgb = _hsl.toRGB()
            objectWillChange.send()
        }
    }
    var saturation: Float{
        get{ _hsl.s_l }
        set{
            assert(0...1 ~= newValue, "Value out of range")
            _hsl.s_l = newValue
            _rgb = _hsl.toRGB()
            objectWillChange.send()
        }
    }
    var lightness: Float{
        get{ _hsl.l }
        set{
            assert(0...1 ~= newValue, "Value out of range")
            _hsl.l = newValue
            _rgb = _hsl.toRGB()
            objectWillChange.send()
        }
    }
    
    var saturation_v: Float{_hsl.s_v}
    var v: Float{_hsl.v}
    
    init(r: Float, g: Float, b: Float) {
        let newRGB = RGB(r: r, g: g, b: b)
        self._rgb = newRGB
        self._hsl = newRGB.toHSLV()
    }
    
    func setHSLV(_ obj: HSLV) {
        self._hsl = obj
        self._rgb = _hsl.toRGB()
        objectWillChange.send()
    }
    func setRGB(_ obj: RGB) {
        self._rgb = obj
        self._hsl = _rgb.toHSLV()
        objectWillChange.send()
    }
//    func setColor(_ newCol: CustomColor) {
//        self.rgb = newCol.rgb
//        self.alpha = newCol.alpha
//    }
//
//    func getHex() -> String {
//        //
//        let r = String(format:"%02X", rgb.r)
//        let g = String(format:"%02X", rgb.g)
//        let b = String(format:"%02X", rgb.b)
//        let a = String(format:"%02X", alpha)
//
//        let result = "#"+r+g+b+a
//        return result
//    }
    
    func toColor() -> Color {
        return Color(red: Double(_rgb.r), green: Double(_rgb.g), blue: Double(_rgb.b), opacity: Double(alpha))
    }
    func toColor2() -> Color {
        return Color(hue: CGFloat(_hsl.h.degrees / 360), saturation: CGFloat(_hsl.s_v), brightness: CGFloat(_hsl.v), opacity: 1)
    }
    
    func generateShades(n: Int,lighter: Bool) -> [HSLV] {

        let base = HSLV(h: _hsl.h.degrees, s: _hsl.s_l, l: 0.5)
        var result = [base]

        let step = 0.5 / Float(n)
        for i in (0..<n) {
            let factor = Float(i) * step
            let newCol: HSLV = {
                if lighter {
                    return HSLV(h: base.h.degrees, s: base.s_l, l: 0.5+factor)
                } else {
                    return HSLV(h: base.h.degrees, s: base.s_l, l: 0.5-factor)
                }
            }()
            result.append(newCol)
        }
        return result
    }
}

// MARK: - Palette
class PaletteList: ObservableObject{
    @Published var palettes: [Palette]
    init(_ palettes: [Palette]) {
        self.palettes = palettes
    }
}
class Palette: ObservableObject, Identifiable {
    let id = UUID()
    var name: String
    @Published var colors: [(id: String, hsl: HSLV)]
    
    init(name: String, _ hslValues: [HSLV]) {
        self.name = name
        colors = hslValues.map({ _hsl in
            (id: UUID().uuidString, hsl: _hsl)
        })
    }
    }


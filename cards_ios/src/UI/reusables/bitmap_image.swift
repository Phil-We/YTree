//
//  bitmap_image.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 4/8/22.
//

import UIKit
import SwiftUI

struct BitMapImageView: View {
    var body: some View {
        VStack{
        Image(bitmap: Bitmap(rows: 200, columns: 200, defaultValue: .red))
            Spacer().frame(height: 30)
        Rectangle().fill(.blue).frame(width: 200, height: 200)
        }
    }
    func makeBitmap() -> [Pixel] {
        return undefined()
    }
}
struct BitmapImage_Previews: PreviewProvider {
    static var previews: some View {
        BitMapImageView()
    }
}




 public struct Pixel {
     public var r, g, b: UInt8
     public var a: UInt8 = 255
 }

 public extension Pixel {
     static let clear = Pixel(r: 0,   g: 0,   b: 0, a: 0)
     static let red   = Pixel(r: 255, g: 0,   b: 0)
     static let green = Pixel(r: 0,   g: 255, b: 0)
     static let blue  = Pixel(r: 0,   g: 0,   b: 255)
 }
typealias Bitmap = Matrix<Pixel>
 extension Image {
     init?(bitmap: Bitmap) {
         let height = bitmap.rows
         let width = bitmap.columns
         let alphaInfo = CGImageAlphaInfo.premultipliedLast
         let bytesPerPixel = MemoryLayout<Pixel>.size
         let bytesPerRow = width * bytesPerPixel

         guard let providerRef = CGDataProvider(data: Data(
             bytes: bitmap.matrix, count: height * bytesPerRow
         ) as CFData) else {
             return nil
         }

         guard let cgImage = CGImage(
             width: width,
             height: height,
             bitsPerComponent: 8,
             bitsPerPixel: bytesPerPixel * 8,
             bytesPerRow: bytesPerRow,
             space: CGColorSpaceCreateDeviceRGB(),
             bitmapInfo: CGBitmapInfo(rawValue: alphaInfo.rawValue),
             provider: providerRef,
             decode: nil,
             shouldInterpolate: true,
             intent: .defaultIntent
         ) else {
             return nil
         }

         self.init(decorative: cgImage, scale: 1.0, orientation: .up)
     }
 }
/*
 public struct Bitmap {
     public private(set) var pixels: [Pixel]
     public let width: Int
     var height: Int {
         return pixels.count / width
     }
     
     subscript(x: Int, y: Int) -> Pixel {
         get { return pixels[y * width + x] }
         set { pixels[y * width + x] = newValue }
     }
     
     public init(width: Int, pixels: [Pixel]) {
         self.width  = width
         self.pixels = pixels
     }
     init(width: Int, height: Int, color: Pixel) {
         self.pixels = Array(repeating: color, count: width * height)
         self.width  = width
     }
     
     private func indexIsValid(row: Int, column: Int) -> Bool {
         return (row >= 0) && (row < height) && (column >= 0) && (column < width)
     }
 }
*/
/*
 public struct Renderer {
     public private(set) var bitmap: Bitmap
     private var i: Int = 0
     private var j: Int = 0
     public init(width: Int, height: Int, backgroundColor: Pixel = .clear) {
         self.bitmap = Bitmap(width: width, height: height, color: backgroundColor)
         draw()
     }
 }

 public extension Renderer {
     mutating func draw() {  // Temporary for testing
         bitmap[i, j] = [Pixel.red, Pixel.green, Pixel.blue][i % 3]
     
         i += 1
         if (i >= bitmap.width) {
             i = 0
             j += 1
             if (j >= bitmap.height) {
                 j = 0
             }
         }
     }
 }
*/

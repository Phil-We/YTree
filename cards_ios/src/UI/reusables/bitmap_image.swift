//
//  bitmap_image.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 4/8/22.
//

import UIKit
import SwiftUI

//struct BitmapImage: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> ViewController {
//           return ViewController()
//       }
//
//       // 3.
//       func updateUIViewController(_ uiViewController: ViewController, context: Context) {
//
//       }
//}

struct BitMapImageView: View {
    var body: some View {
        Image(bitmap: Bitmap(width: 200, height: 200, color: .blue))
    }
}
struct BitmapImage_Previews: PreviewProvider {
    static var previews: some View {
        BitMapImageView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}

//class ViewController: UIViewController {
//    let imageView = UIImageView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUpImageView()
//
//        let displayLink = CADisplayLink(target: self, selector: #selector(update))
//        displayLink.add(to: .main, forMode: .common)
////        var bitmap = Bitmap(width: 8, height: 8, color: .white)
////        bitmap[0, 0] = Color.blue
////
////        imageView.image = UIImage(bitmap: bitmap)
//    }
//    @objc func update(_ displayLink: CADisplayLink) {
//        let x = Int(displayLink.timestamp) % 8
//        var renderer = Renderer()
//        renderer.draw(x: x)
//        imageView.image = UIImage(bitmap: renderer.bitmap)
//    }
//}
//
//extension ViewController {
//    func setUpImageView() {
//        view.addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .black
//        imageView.layer.magnificationFilter = .nearest
//    }
//}
//
//struct RGBA {
//    var r, g, b: UInt8
//    var a: UInt8 = 255
//}
//extension RGBA {
//    static let clear = RGBA(r: 0, g: 0, b: 0, a: 0)
//    static let black = RGBA(r: 0, g: 0, b: 0)
//    static let white = RGBA(r: 255, g: 255, b: 255)
//    static let gray = RGBA(r: 192, g: 192, b: 192)
//    static let red = RGBA(r: 255, g: 0, b: 0)
//    static let green = RGBA(r: 0, g: 255, b: 0)
//    static let blue = RGBA(r: 0, g: 0, b: 255)
//}
//
//struct Bitmap {
//    let width: Int
//    var pixels: [RGBA]
//
//    var height: Int {
//        pixels.count / width
//    }
//
//    init(width: Int, height: Int, color: RGBA) {
//        self.width = width
//        pixels = Array(repeating: color, count: width * height)
//    }
//
//    subscript(x: Int, y: Int) -> RGBA {
//        get { pixels[y * width + x] }
//        set { pixels[y * width + x] = newValue }
//    }
//}
//
//extension UIImage {
//    convenience init?(bitmap: Bitmap) {
//        let alphaInfo = CGImageAlphaInfo.premultipliedLast
//        let bytesPerPixel = MemoryLayout<RGBA>.stride
//        let bytesPerRow = bitmap.width * bytesPerPixel
//
//        guard let providerRef = CGDataProvider(data: Data(bytes: bitmap.pixels, count: bitmap.height * bytesPerRow) as CFData) else {
//            return nil
//        }
//
//        guard let cgImage = CGImage(
//            width: bitmap.width,
//            height: bitmap.height,
//            bitsPerComponent: 8,
//            bitsPerPixel: bytesPerPixel * 8,
//            bytesPerRow: bytesPerRow,
//            space: CGColorSpaceCreateDeviceRGB(),
//            bitmapInfo: CGBitmapInfo(rawValue: alphaInfo.rawValue),
//            provider: providerRef,
//            decode: nil,
//            shouldInterpolate: true,
//            intent: .defaultIntent
//        ) else {
//            return nil
//        }
//
//        self.init(cgImage: cgImage)
//    }
//}
//
//struct Renderer {
//    var bitmap = Bitmap(width: 8, height: 8, color: .white)
//
//    mutating func draw(x: Int) {
//        bitmap[x, 0] = RGBA.blue
//    }
//}


 public struct RGBA {
     public var r, g, b, a: UInt8
     
     public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) {
         self.r = r
         self.g = g
         self.b = b
         self.a = a
     }
 }

 public extension RGBA {
     static let clear = RGBA(r: 0,   g: 0,   b: 0, a: 0)
     static let red   = RGBA(r: 255, g: 0,   b: 0)
     static let green = RGBA(r: 0,   g: 255, b: 0)
     static let blue  = RGBA(r: 0,   g: 0,   b: 255)
 }

 extension Image {
     init?(bitmap: Bitmap) {
         let alphaInfo = CGImageAlphaInfo.premultipliedLast
         let bytesPerPixel = MemoryLayout<Color>.size
         let bytesPerRow = bitmap.width * bytesPerPixel

         guard let providerRef = CGDataProvider(data: Data(
             bytes: bitmap.pixels, count: bitmap.height * bytesPerRow
         ) as CFData) else {
             return nil
         }

         guard let cgImage = CGImage(
             width: bitmap.width,
             height: bitmap.height,
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

 public struct Bitmap {
     public private(set) var pixels: [RGBA]
     public let width: Int
     
     public init(width: Int, pixels: [RGBA]) {
         self.width  = width
         self.pixels = pixels
     }
 }

 public extension Bitmap {
     var height: Int {
         return pixels.count / width
     }
     
     subscript(x: Int, y: Int) -> RGBA {
         get { return pixels[y * width + x] }
         set { pixels[y * width + x] = newValue }
     }

     init(width: Int, height: Int, color: RGBA) {
         self.pixels = Array(repeating: color, count: width * height)
         self.width  = width
     }
 }

 public struct Renderer {
     public private(set) var bitmap: Bitmap
     private var i: Int = 0
     private var j: Int = 0
     public init(width: Int, height: Int, backgroundColor: RGBA = .clear) {
         self.bitmap = Bitmap(width: width, height: height, color: backgroundColor)
     }
 }

 public extension Renderer {
     mutating func draw() {  // Temporary for testing
         bitmap[i, j] = [RGBA.red, RGBA.green, RGBA.blue][i % 3]
     
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
 

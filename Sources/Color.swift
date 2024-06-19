import Foundation
import SwiftUI
#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#elseif os(watchOS)
    import WatchKit
#endif

public typealias Kelvin = Double

#if os(macOS)
    typealias SystemColor = NSColor
#else
    typealias SystemColor = UIColor
#endif

@available(iOS 13, tvOS 13, macOS 13, *)
public extension Color {
    init(temperature: Kelvin) {
        let components = componentsForColorTemperature(temperature: temperature)
        self.init(red: components.red, green: components.green, blue: components.blue)
    }
}

/// Color can now be stored in UserDefaults
///
/// Inspired by: https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e
@available(iOS 14, tvOS 14, macOS 13, *)
extension Color: @retroactive RawRepresentable {
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .black
            return
        }
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: SystemColor.self, from: data) ?? .black
            self = Color(color)
        } catch {
            self = .black
        }
    }

    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: SystemColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()

        } catch {
            return ""
        }
    }
}

@available(iOS 14, tvOS 14, macOS 13, *)
public extension Color {
    var contrastingColor: Color {
        let components = cgColor?.components

        let compRed: CGFloat = (components?[0] ?? 0.0) * 0.299
        let compGreen: CGFloat = (components?[1] ?? 0.0) * 0.587
        let compBlue: CGFloat = (components?[2] ?? 0.0) * 0.114

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = (compRed + compGreen + compBlue)

        // bright colors - black font
        // dark colors - white font
        let col: CGFloat = luminance > 0.7 ? 0.1 : 1

        return Color(red: col, green: col, blue: col)
    }
}

@available(iOS 14, tvOS 14, macOS 13, *)
private extension Color {
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        #if os(macOS)
            SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        // Note that non RGB color will raise an exception, that I don't now how to catch because it is an Objc exception.
        #else
            guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
                // Pay attention that the color should be convertible into RGB format
                // Colors using hue, saturation and brightness won't work
                return nil
            }
        #endif

        return (r, g, b, a)
    }
}

@available(iOS 14, tvOS 14, macOS 13, *)
extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)

        self.init(red: r, green: g, blue: b)
    }

    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = colorComponents else {
            return
        }

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }
}

// Algorithm taken from Tanner Helland's post: http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
func componentsForColorTemperature(temperature: Kelvin) -> (red: Double, green: Double, blue: Double) {
    let percentKelvin = temperature / 100
    let red, green, blue: Double

    red = clamp(percentKelvin <= 66 ? 255 : (329.698727446 * pow(percentKelvin - 60, -0.1332047592)))
    green = clamp(percentKelvin <= 66 ? (99.4708025861 * log(percentKelvin) - 161.1195681661) : 288.1221695283 * pow(percentKelvin - 60, -0.0755148492))
    blue = clamp(percentKelvin >= 66 ? 255 : (percentKelvin <= 19 ? 0 : 138.5177312231 * log(percentKelvin - 10) - 305.0447927307))

    return (red: red / 255, green: green / 255, blue: blue / 255)

    func clamp(_ value: Double) -> Double {
        return value > 255 ? 255 : (value < 0 ? 0 : value)
    }
}

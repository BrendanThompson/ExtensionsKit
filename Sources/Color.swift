import Foundation
import SwiftUI
import UIKit

public typealias Kelvin = Double

@available(iOS 13, tvOS 13, *)
public extension Color {
    init(temperature: Kelvin) {
        let components = componentsForColorTemperature(temperature: temperature)
        self.init(red: components.red, green: components.green, blue: components.blue)
    }
}

public extension Color: RawRepresentable {

    public init?(rawValue: String) {

        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }

        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            self = Color(color)
        }catch{
            self = .black
        }

    }

    public var rawValue: String {

        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()

        }catch{

            return ""

        }

    }

}

// Algorithm taken from Tanner Helland's post: http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
func componentsForColorTemperature(temperature: Kelvin) -> (red: Double, green: Double, blue: Double) {
    let percentKelvin = temperature / 100;
    let red, green, blue: Double

    red = clamp(percentKelvin <= 66 ? 255 : (329.698727446 * pow(percentKelvin - 60, -0.1332047592)));
    green = clamp(percentKelvin <= 66 ? (99.4708025861 * log(percentKelvin) - 161.1195681661) : 288.1221695283 * pow(percentKelvin - 60, -0.0755148492));
    blue = clamp(percentKelvin >= 66 ? 255 : (percentKelvin <= 19 ? 0 : 138.5177312231 * log(percentKelvin - 10) - 305.0447927307));

    return (red: red / 255, green: green / 255, blue: blue / 255)

    func clamp(_ value: Double) -> Double
    {
        return value > 255 ? 255 : (value < 0 ? 0 : value);
    }
}

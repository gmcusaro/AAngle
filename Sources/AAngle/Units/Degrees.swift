import Foundation

public struct Degrees: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Degrees` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in degrees as a `Double`.
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
    }
    
    public static let normalizationValue: Double = 360.0
    
    /// Converts the `Degrees` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `Degrees` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in degrees.
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .degrees)
    }
}

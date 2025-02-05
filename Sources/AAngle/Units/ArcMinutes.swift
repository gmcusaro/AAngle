import Foundation

public struct ArcMinutes: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `ArcMinutes` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in arc minute as a `Double`.
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
    }
    
    public static let normalizationValue: Double = 21_600
    
    /// Converts the `ArcMinutes` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `ArcMinutes` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in arc minutes.
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .arcMinutes)
    }
}

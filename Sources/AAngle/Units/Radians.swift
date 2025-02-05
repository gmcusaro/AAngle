import Foundation

public struct Radians: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Radians` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in radian as a `Double`.
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
    }
    
    public static let normalizationValue: Double = 2 * .pi
    
    /// Converts the `Radians` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the  `Radians` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in radians.
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .radians)
    }
}

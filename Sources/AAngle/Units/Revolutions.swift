import Foundation

public struct Revolutions: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Revolutions` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in revolution as a `Double`.
    @inlinable
    public init(_ rawValue: Double) {
        // Ensure the rawValue is finite (not NaN or infinite)
        precondition(rawValue.isFinite, "Revolutions must be initialized with a finite value.")
        self.rawValue = rawValue
    }
    
    /// The normalization value used for converting and normalizing revolutions.
    public static let normalizationValue: Double = 1.0
    
    /// Converts the `Revolutions` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `Revolutions` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in revolutions.
    @inlinable
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .revolutions)
    }
}

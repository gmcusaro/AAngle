import Foundation

public struct Gradians: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Gradians` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in gradian as a `Double`.
    @inlinable
    public init(_ rawValue: Double) {
        // Ensure the rawValue is finite (not NaN or infinite)
        precondition(rawValue.isFinite, "Gradians must be initialized with a finite value.")
        self.rawValue = rawValue
    }
    
    /// The normalization value used for converting and normalizing gradians.
    public static let normalizationValue: Double = 400.0
        
    /// Converts the `Gradians` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `Gradians` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in gradians.
    @inlinable
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .gradians)
    }
}

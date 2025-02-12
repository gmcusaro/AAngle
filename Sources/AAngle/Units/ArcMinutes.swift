import Foundation

public struct ArcMinutes: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double

    /// Initializes a `ArcMinutes` instance with a raw `Double` value.
    ///
    /// - Parameter rawValue: The angle in arc minute as a `Double`.
    @inlinable
    public init(_ rawValue: Double) {
        // Ensure the rawValue is finite (not NaN or infinite)
        precondition(rawValue.isFinite, "Arc Minutes must be initialized with a finite value.")
        self.rawValue = rawValue
    }

    /// The normalization value used for converting and normalizing arc minutes.
    public static let normalizationValue: Double = 21_600

    /// Converts the `ArcMinutes` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `ArcMinutes` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in arc minutes.
    @inlinable
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .arcMinutes)
    }
}

import Foundation

public struct ArcSeconds: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `ArcSeconds` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in arc second as a `Double`.
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
    }
    
    public static let normalizationValue: Double = 1_296_000
    
    /// Converts the `ArcSeconds` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `ArcSeconds` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in arc seconds.
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .arcSeconds)
    }
}

import Foundation

public struct Degrees: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Degrees` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in degrees as a `Double`.
    @inlinable
    public init(_ rawValue: Double) {
        // Ensure the rawValue is finite (not NaN or infinite)
        precondition(rawValue.isFinite, "Degrees must be initialized with a finite value.")
        self.rawValue = rawValue
    }
    
    /// The normalization value used for converting and normalizing degrees.
    public static let normalizationValue: Double = 360.0
    
    /// Converts the `Degrees` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `Degrees` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in degrees.
    @inlinable
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .degrees)
    }
}

extension Degrees {
    /// Compute the opposite angle (adds 180°)
    @inlinable
    public var opposite: Degrees {
         var oppositeAngle = Degrees(rawValue + Self.normalizationValue / 2)
         oppositeAngle.normalize()
         return oppositeAngle
     }

    /// Compute the adjacent angles (90° and 270° away)
    @inlinable
    public func adjacentAngles() -> [Degrees] {
        let adj1 = (rawValue + 90).truncatingRemainder(dividingBy: Self.normalizationValue)
        let adj2 = (rawValue - 90).truncatingRemainder(dividingBy: Self.normalizationValue)
        
        let normalizedAdj1 = adj1 < 0 ? adj1 + Self.normalizationValue : adj1
        let normalizedAdj2 = adj2 < 0 ? adj2 + Self.normalizationValue : adj2
        
        return [Degrees(normalizedAdj1), Degrees(normalizedAdj2)]
    }
}

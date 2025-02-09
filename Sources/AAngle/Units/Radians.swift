import Foundation

public struct Radians: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Radians` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in radian as a `Double`.
    @inlinable
    public init(_ rawValue: Double) {
        // Ensure the rawValue is finite (not NaN or infinite)
        precondition(rawValue.isFinite, "Radians must be initialized with a finite value.")
        self.rawValue = rawValue
    }
    
    /// The normalization value used for converting and normalizing radians.
    public static let normalizationValue: Double = 2 * .pi
    
    /// Converts the `Radians` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the  `Radians` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in radians.
    @inlinable
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .radians)
    }
}

extension Radians {
    /// Get the sine of the angle
    @inlinable
    public var sine: Double {
        return sin(rawValue)
    }
    
    /// Get the cosine of the angle
    @inlinable
    public var cosine: Double {
        return cos(rawValue)
    }
    
    /// Get the tangent of the angle
    @inlinable
    public var tangent: Double {
        return tan(rawValue)
    }
    
    /// Get the cotangent of the angle (1 / tan)
    @inlinable
    public var cotangent: Double? {
        return tangent != 0 ? 1 / tangent : nil
    }
    
    /// Get the secant of the angle (1 / cos)
    @inlinable
    public var secant: Double? {
        return cosine != 0 ? 1 / cosine : nil
    }
    
    /// Get the cosecant of the angle (1 / sin)
    @inlinable
    public var cosecant: Double? {
        return sine != 0 ? 1 / sine : nil
    }
    
    /// Returns the opposite leg length given the hypotenuse
    @inlinable
    public func oppositeLeg(hypotenuse: Double) -> Double {
        return hypotenuse * sine
    }

    /// Returns the adjacent leg length given the hypotenuse
    @inlinable
    public func adjacentLeg(hypotenuse: Double) -> Double {
        return hypotenuse * cosine
    }
    
    /// Returns the hypotenuse given the opposite leg length
    @inlinable
    public func hypotenuse(fromOppositeLeg oppositeLeg: Double) -> Double {
        return oppositeLeg / sine
    }
    
    /// Returns the hypotenuse given the adjacent leg length
    @inlinable
    public func hypotenuse(fromAdjacentLeg adjacentLeg: Double) -> Double {
        return adjacentLeg / cosine
    }
    
    /// Returns the opposite leg given the adjacent leg
    @inlinable
    public func oppositeLeg(fromAdjacentLeg adjacentLeg: Double) -> Double {
        return adjacentLeg * tangent
    }

    /// Returns the adjacent leg given the opposite leg
    @inlinable
    public func adjacentLeg(fromOppositeLeg oppositeLeg: Double) -> Double {
        return oppositeLeg / tangent
    }
}

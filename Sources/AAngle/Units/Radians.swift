import Foundation

public struct Radians: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Radians` instance with a raw `Double` value.
    /// 
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
    
    /// The secant of the angle (1 / cosine).
    @inlinable
    public var secant: Double? {
        return cosine != 0 ? 1 / cosine : nil
    }
    
    /// The cosecant of the angle (1 / sine).
    @inlinable
    public var cosecant: Double? {
        return sine != 0 ? 1 / sine : nil
    }
    
    /// Computes the opposite leg of a right triangle given the hypotenuse.
    ///
    /// - Parameter hypotenuse: The length of the hypotenuse.
    /// - Returns: The length of the opposite leg.
    @inlinable
    public func oppositeLeg(hypotenuse: Double) -> Double {
        return hypotenuse * sine
    }
    
    /// Computes the adjacent leg of a right triangle given the hypotenuse.
    ///
    /// - Parameter hypotenuse: The length of the hypotenuse.
    /// - Returns: The length of the adjacent leg.
    @inlinable
    public func adjacentLeg(hypotenuse: Double) -> Double {
        return hypotenuse * cosine
    }
    
    /// Computes the hypotenuse given the opposite leg of a right triangle.
    ///
    /// - Parameter oppositeLeg: The length of the opposite leg.
    /// - Returns: The length of the hypotenuse.
    @inlinable
    public func hypotenuse(fromOppositeLeg oppositeLeg: Double) -> Double {
        return oppositeLeg / sine
    }
    
    /// Computes the hypotenuse given the adjacent leg of a right triangle.
    ///
    /// - Parameter adjacentLeg: The length of the adjacent leg.
    /// - Returns: The length of the hypotenuse.
    @inlinable
    public func hypotenuse(fromAdjacentLeg adjacentLeg: Double) -> Double {
        return adjacentLeg / cosine
    }
    
    /// Computes the opposite leg given the adjacent leg of a right triangle.
    ///
    /// - Parameter adjacentLeg: The length of the adjacent leg.
    /// - Returns: The length of the opposite leg.
    @inlinable
    public func oppositeLeg(fromAdjacentLeg adjacentLeg: Double) -> Double {
        return adjacentLeg * tangent
    }
    
    /// Computes the adjacent leg given the opposite leg of a right triangle.
    ///
    /// - Parameter oppositeLeg: The length of the opposite leg.
    /// - Returns: The length of the adjacent leg.
    @inlinable
    public func adjacentLeg(fromOppositeLeg oppositeLeg: Double) -> Double {
        return oppositeLeg / tangent
    }
}

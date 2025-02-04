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
    
    /// Converts the current angle to the specified `AngleType`.
    /// - Parameter type: The target `AngleType` to convert to.
    /// - Returns: An instance conforming to `Anglable` representing the converted angle.
    public func convertTo(_ type: AngleType) -> any Anglable {
        switch type {
        case .gradians:    return Gradians(self)
        case .degrees:     return Degrees(self)
        case .radians:     return self
        case .revolutions: return Revolutions(self)
        case .arcSeconds:  return ArcSeconds(self)
        case .arcMinutes:  return ArcMinutes(self)
        }
    }
}

public extension Radians {
    /// Initializes a `Radians` instance from a `Gradians` value.
    /// - Parameter gradians: The angle in gradians to convert to radians.
    init(_ gradians: Gradians) {
        self.rawValue = gradians.rawValue * .pi / 200.0
    }
    
    /// Initializes a `Radians` instance from a `Degrees` value.
    /// - Parameter degrees: The angle in degrees to convert to radians.
    init(_ degrees: Degrees) {
        self.rawValue = degrees.rawValue * .pi / 180.0
    }
    
    /// Initializes a `Radians` instance from a `Revolutions` value.
    /// - Parameter revolutions: The number of revolutions to convert to radians.
    init(_ revolutions: Revolutions) {
        self.rawValue = revolutions.rawValue * Radians.normalizationValue
    }
    
    /// Initializes a `Radians` instance from an `ArcSeconds` value.
    /// - Parameter arcseconds: The angle in arc seconds to convert to radians.
    init(_ arcseconds: ArcSeconds) {
        self.rawValue = (arcseconds.rawValue / 3600) * (.pi / 180)
    }
    
    /// Initializes a `Radians` instance from an `ArcMinutes` value.
    /// - Parameter arcMinutes: The angle in arc minutes to convert to radians.
    init(_ arcMinutes: ArcMinutes) {
        self.rawValue = arcMinutes.rawValue * (Double.pi / (180.0 * 60.0))
    }
}

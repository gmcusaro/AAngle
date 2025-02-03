import Foundation

public struct Revolutions: Hashable, Codable, Sendable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Revolutions` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in revolution as a `Double`.
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
    }
    
    public static let normalizationValue: Double = 1.0
    
    /// Converts the `Revolutions` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `Revolutions` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in revolutions.
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .revolutions)
    }
    
    /// Converts the current angle to the specified `AngleType`.
    /// - Parameter type: The target `AngleType` to convert to.
    /// - Returns: An instance conforming to `Anglable` representing the converted angle.
    public func convertTo(_ type: AngleType) -> any Anglable {
        switch type {
        case .gradians:    return Gradians(self)
        case .degrees:     return Degrees(self)
        case .radians:     return Radians(self)
        case .revolutions: return self
        case .arcSeconds:  return ArcSeconds(self)
        case .arcMinutes:  return ArcMinutes(self)
        }
    }
}

public extension Revolutions {
    /// Initializes a `Revolutions` instance from a `Gradians` value.
    /// - Parameter gradians: The angle in gradians to convert to revolutions.
    init(_ gradians: Gradians) {
        self.rawValue = gradians.rawValue / Gradians.normalizationValue
    }
    
    /// Initializes a `Revolutions` instance from a `Radians` value.
    /// - Parameter radians: The angle in radians to convert to revolutions.
    init(_ radians: Radians) {
        self.rawValue = radians.rawValue / Radians.normalizationValue
    }
    
    /// Initializes a `Revolutions` instance from a `Degrees` value.
    /// - Parameter degrees: The angle in degrees to convert to revolutions.
    init(_ degrees: Degrees) {
        self.rawValue = degrees.rawValue / Degrees.normalizationValue
    }
    
    /// Initializes a `Revolutions` instance from an `ArcSeconds` value.
    /// - Parameter arcseconds: The angle in arc seconds to convert to revolutions.
    init(_ arcseconds: ArcSeconds) {
        self.rawValue = arcseconds.rawValue / ArcSeconds.normalizationValue
    }
    
    /// Initializes a `Revolutions` instance from an `ArcMinutes` value.
    /// - Parameter arcMinutes: The angle in arc minutes to convert to revolutions.
    init(_ arcMinutes: ArcMinutes) {
        self.rawValue = arcMinutes.rawValue / ArcMinutes.normalizationValue
    }
}

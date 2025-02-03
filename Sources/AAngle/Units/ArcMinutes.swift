import Foundation

public struct ArcMinutes: Hashable, Codable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `ArcMinutes` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in arc minute as a `Double`.
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
    }
    
    public static let normalizationValue: Double = 21600.00
    
    /// Converts the `ArcMinutes` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `ArcMinutes` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in arc minutes.
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .arcMinutes)
    }
    
    /// Converts the current angle to the specified `AngleType`.
    /// - Parameter type: The target `AngleType` to convert to.
    /// - Returns: An instance conforming to `Anglable` representing the converted angle.
    public func convertTo(_ type: AngleType) -> any Anglable {
        switch type {
        case .gradians:    return Gradians(self)
        case .degrees:     return Degrees(self)
        case .radians:     return Radians(self)
        case .revolutions: return Revolutions(self)
        case .arcSeconds:  return ArcSeconds(self)
        case .arcMinutes:  return self
        }
    }
}

public extension ArcMinutes {
    /// Initializes an `ArcMinutes` instance from a `Gradians` value.
    /// - Parameter gradians: The angle in gradians to convert to arc minutes.
    init(_ gradians: Gradians) {
        self.rawValue = gradians.rawValue * 54.0
    }
    
    /// Initializes an `ArcMinutes` instance from a `Degrees` value.
    /// - Parameter degrees: The angle in degrees to convert to arc minutes.
    init(_ degrees: Degrees) {
        self.rawValue = degrees.rawValue * 60.0
    }
    
    /// Initializes an `ArcMinutes` instance from a `Radians` value.
    /// - Parameter radians: The angle in radians to convert to arc minutes.
    init(_ radians: Radians) {
        self.rawValue = radians.rawValue * (180.0 * 60.0 / Double.pi)
    }
    
    /// Initializes an `ArcMinutes` instance from a `Revolutions` value.
    /// - Parameter revolutions: The number of revolutions to convert to arc minutes.
    init(_ revolutions: Revolutions) {
        self.rawValue = revolutions.rawValue * ArcMinutes.normalizationValue
    }
    
    /// Initializes an `ArcMinutes` instance from an `ArcSeconds` value.
    /// - Parameter arcseconds: The angle in arc seconds to convert to arc minutes.
    init(_ arcseconds: ArcSeconds) {
        self.rawValue = arcseconds.rawValue / 60.0
    }
}

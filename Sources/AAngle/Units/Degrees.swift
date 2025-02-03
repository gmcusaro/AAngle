import Foundation

public struct Degrees: Hashable, Codable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Degrees` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in degrees as a `Double`.
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
    }
    
    public static let normalizationValue: Double = 360.0
    
    /// Converts the `Degrees` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `Degrees` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in degrees.
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .degrees)
    }
    
    /// Converts the current angle to the specified `AngleType`.
    /// - Parameter type: The target `AngleType` to convert to.
    /// - Returns: An instance conforming to `Anglable` representing the converted angle.
    public func convertTo(_ type: AngleType) -> any Anglable {
        switch type {
        case .gradians:    return Gradians(self)
        case .degrees:     return self
        case .radians:     return Radians(self)
        case .revolutions: return Revolutions(self)
        case .arcSeconds:  return ArcSeconds(self)
        case .arcMinutes:  return ArcMinutes(self)
        }
    }
}

extension Degrees {
    /// Initializes a `Degrees` instance from a `Gradians` value.
    /// - Parameter gradian: The angle in gradians to convert to degrees.
    init(_ gradian: Gradians) {
        self.rawValue = gradian.rawValue * (9.0 / 10.0)
    }
    
    /// Initializes a `Degrees` instance from a `Radians` value.
    /// - Parameter radian: The angle in radians to convert to degrees.
    init(_ radian: Radians) {
        self.rawValue = radian.rawValue * 180 / .pi
    }
    
    /// Initializes a `Degrees` instance from a `Revolutions` value.
    /// - Parameter revolution: The number of revolutions to convert to degrees.
    init(_ revolution: Revolutions) {
        self.rawValue = revolution.rawValue * Degrees.normalizationValue
    }
    
    /// Initializes a `Degrees` instance from an `ArcSeconds` value.
    /// - Parameter arcSecond: The angle in arc seconds to convert to degrees.
    init(_ arcSecond: ArcSeconds) {
        self.rawValue = arcSecond.rawValue / 3600
    }
    
    /// Initializes a `Degrees` instance from an `ArcMinutes` value.
    /// - Parameter arcMinutes: The angle in arc minutes to convert to degrees.
    init(_ arcMinutes: ArcMinutes) {
        self.rawValue = arcMinutes.rawValue / 60.0
    }
}

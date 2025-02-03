import Foundation

public struct Gradians: Hashable, Codable, Anglable {
    public var rawValue: Double
    
    /// Initializes a `Gradians` instance with a raw `Double` value.
    /// - Parameter rawValue: The angle in gradian as a `Double`.
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
    }
    
    public static let normalizationValue: Double = 400.0
    
    /// Converts the `Gradians` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `Gradians` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in gradians.
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .gradians)
    }
    
    /// Converts the current angle to the specified `AngleType`.
    /// - Parameter type: The target `AngleType` to convert to.
    /// - Returns: An instance conforming to `Anglable` representing the converted angle.
    public func convertTo(_ type: AngleType) -> any Anglable {
        switch type {
        case .gradians:    return self
        case .degrees:     return Degrees(self)
        case .radians:     return Radians(self)
        case .revolutions: return Revolutions(self)
        case .arcSeconds:  return ArcSeconds(self)
        case .arcMinutes:  return ArcMinutes(self)
        }
    }
}

public extension Gradians {
    /// Initializes a `Gradians` instance from a `Degrees` value.
    /// - Parameter degrees: The angle in degrees to convert to gradians.
    init(_ degrees: Degrees) {
        self.rawValue = degrees.rawValue * (10.0 / 9.0)
    }
    
    /// Initializes a `Gradians` instance from a `Radians` value.
    /// - Parameter radians: The angle in radians to convert to gradians.
    init(_ radian: Radians) {
        self.rawValue = radian.rawValue * (200.0 / .pi)
    }
    
    /// Initializes a `Gradians` instance from a `Revolutions` value.
    /// - Parameter revolution: The number of revolutions to convert to gradians.
    init(_ revolution: Revolutions) {
        self.rawValue = revolution.rawValue * Revolutions.normalizationValue
    }
    
    /// Initializes a `Gradians` instance from an `ArcSeconds` value.
    /// - Parameter arcSecond: The angle in arc seconds to convert to gradians.
    init(_ arcSecond: ArcSeconds) {
        self.rawValue = (arcSecond.rawValue / 3600) * (10.0 / 9.0)
    }
    
    /// Initializes a `Gradians` instance from an `ArcMinutes` value.
    /// - Parameter arcMinutes: The angle in arc minutes to convert to gradians.
    init(_ arcMinutes: ArcMinutes) {
        self.rawValue = arcMinutes.rawValue / 54.0
    }
}

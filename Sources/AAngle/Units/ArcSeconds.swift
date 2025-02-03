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
    
    /// Converts the current angle to the specified `AngleType`.
    /// - Parameter type: The target `AngleType` to convert to.
    /// - Returns: An instance conforming to `Anglable` representing the converted angle.
    public func convertTo(_ type: AngleType) -> any Anglable {
        switch type {
        case .gradians:    return Gradians(self)
        case .degrees:     return Degrees(self)
        case .radians:     return Radians(self)
        case .revolutions: return Revolutions(self)
        case .arcSeconds:  return self
        case .arcMinutes:  return ArcMinutes(self)
        }
    }
}

public extension ArcSeconds {
    /// Initializes a `ArcSeconds` instance from a `Gradians` value.
    /// - Parameter gradians: The angle in gradians to convert to arc seconds.
    init(_ gradians: Gradians) {
        self.rawValue = gradians.rawValue * (9.0 / 10.0) * 3600
    }
    
    /// Initializes a `ArcSeconds` instance from a `Radians` value.
    /// - Parameter radians: The angle in radians to convert to arc seconds.
    init(_ radians: Radians) {
        self.rawValue = radians.rawValue * (180 / .pi) * 3600
    }
    
    /// Initializes a `ArcSeconds` instance from a `Degrees` value.
    /// - Parameter degrees: The angle in degrees to convert to arc seconds.
    init(_ degrees: Degrees) {
        self.rawValue = degrees.rawValue * 3600
    }
    
    /// Initializes a `ArcSeconds` instance from a `Revolutions` value.
    /// - Parameter revolutions: The number of revolutions to convert to arc seconds.
    init(_ revolutions: Revolutions) {
        self.rawValue = revolutions.rawValue * ArcSeconds.normalizationValue
    }
    
    /// Initializes a `ArcSeconds` instance from an `ArcMinutes` value.
    /// - Parameter arcMinutes: The angle in arc minutes to convert to arc seconds.
    init(_ arcMinutes: ArcMinutes) {
        self.rawValue = arcMinutes.rawValue * 60.0
    }
}

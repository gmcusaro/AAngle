import Foundation

public enum AngleType: String, Codable, Equatable, Hashable {
    case gradians, degrees, radians, revolutions, arcSeconds, arcMinutes
}

public extension AngleType {
    /// Human-readable description of the angle type.
    var description: String {
        switch self {
        case .gradians:    return "gradians"
        case .degrees:     return "degrees"
        case .radians:     return "radians"
        case .revolutions: return "revolutions"
        case .arcSeconds:  return "arc seconds"
        case .arcMinutes:  return "arc minutes"
        }
    }
}

public extension AngleType {
    /// Initializes an angle instance using a floating-point value.
    ///
    /// - Parameter value: The value of the angle in the specified `AngleType` unit.
    /// - Returns: An `Anglable` instance representing the angle.
    func initAngle<T: BinaryFloatingPoint>(_ value: T) -> any Anglable {
        self.initAngle(Double(value))
    }
    
    /// Initializes an angle instance using an integer value.
    ///
    /// - Parameter value: The value of the angle in the specified `AngleType` unit.
    /// - Returns: An `Anglable` instance representing the angle.
    func initAngle<T: BinaryInteger>(_ value: T) -> any Anglable {
        self.initAngle(Double(value))
    }
    
    /// Initializes an angle instance using a `Double` value.
    ///
    /// - Parameter value: The value of the angle in the specified `AngleType` unit.
    /// - Returns: An `Anglable` instance representing the angle.
    func initAngle(_ value: Double) -> any Anglable {
        switch self {
        case .degrees:
            return Degrees(value)
        case .radians:
            return Radians(value)
        case .gradians:
            return Gradians(value)
        case .revolutions:
            return Revolutions(value)
        case .arcMinutes:
            return ArcMinutes(value)
        case .arcSeconds:
            return ArcSeconds(value)
        }
    }
    
    /// Converts an existing `Anglable` instance to the specified `AngleType`.
    ///
    /// - Parameter value: An existing `Anglable` instance to be converted.
    /// - Returns: A new `Anglable` instance in the specified `AngleType` unit.
    func initAngle(_ value: any Anglable) -> any Anglable {
        switch self {
        case .degrees:
            return Degrees(value)
        case .radians:
            return Radians(value)
        case .gradians:
            return Gradians(value)
        case .revolutions:
            return Revolutions(value)
        case .arcMinutes:
            return ArcMinutes(value)
        case .arcSeconds:
            return ArcSeconds(value)
        }
    }
}

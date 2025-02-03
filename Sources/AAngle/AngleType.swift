import Foundation

public enum AngleType: String, Codable, Equatable, Hashable {
    case gradians, degrees, radians, revolutions, arcSeconds, arcMinutes
}

public extension AngleType {
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
    func instantiateAngle<T: BinaryFloatingPoint>(_ value: T) -> (any Anglable)? {
        instantiateAngle(Double(value))
    }

    func instantiateAngle<T: BinaryInteger>(_ value: T) -> (any Anglable)? {
        instantiateAngle(Double(value))
    }

    func instantiateAngle(_ value: Double) -> (any Anglable)? {
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

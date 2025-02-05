import Foundation

// MARK:- AngleType Protocol
public protocol Anglable: Codable, Hashable, Equatable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Sendable {
    var rawValue: Double { get set }
    init(_ rawValue: Double)
    
    static var normalizationValue: Double { get }
    
    mutating func normalize()
    func normalized() -> Self
    func toMeasurement() -> Measurement<UnitAngle>
    
    /// Initializes an `Anglable` instance from another `Anglable` type.
    /// - Parameter angle: The angle to convert.
    init<T: Anglable>(_ angle: T)
}

extension Anglable {
    public static var tolerance: Double { 1e-10 }

    public mutating func normalize(by value: Double) {
        guard rawValue.isFinite else { return }
        self.rawValue = rawValue.truncatingRemainder(dividingBy: value)
        if rawValue < 0.0 { rawValue += value }
    }
    public func normalized(by value: Double) -> Self {
        var angle = self
        angle.normalize(by: value)
        return angle
    }
    public mutating func normalize() {
        normalize(by: Self.normalizationValue)
    }
    public func normalized() -> Self {
        return normalized(by: Self.normalizationValue)
    }
}

public extension Anglable {
    init() {
        self.init(0.0)
    }
    
    init(floatLiteral value: Double) {
        self.init(value)
    }

    init(integerLiteral value: Int) {
        self.init(Double(value))
    }

    init<T: BinaryInteger>(_ value: T) {
        self.init(Double(value))
    }

    init<T: BinaryFloatingPoint>(_ value: T) {
        self.init(Double(value))
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        var result = Self(lhs.rawValue + rhs.rawValue)
        result.normalize()
        return result
    }
    static func + (lhs: Self, rhs: Double) -> Self {
        var result = Self(lhs.rawValue + rhs)
        result.normalize()
        return result
    }
    static func + (lhs: Self, rhs: Int) -> Self {
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    static func + <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    static func + <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    static func += (lhs: inout Self, rhs: Self) {
        lhs.rawValue += rhs.rawValue
        lhs.normalize()
    }
    static func += (lhs: inout Self, rhs: Double) {
        lhs.rawValue += rhs
        lhs.normalize()
    }
    static func += (lhs: inout Self, rhs: Int) {
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    static func += <T: BinaryInteger>(lhs: inout Self, rhs: T){
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    static func += <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        lhs.rawValue += lhs.rawValue + Double(rhs)
        lhs.normalize()
    }
    static func - (lhs: Self, rhs: Self) -> Self {
        var result = Self(lhs.rawValue - rhs.rawValue)
        result.normalize()
        return result
    }
    static func - (lhs: Self, rhs: Double) -> Self {
        var result = Self(lhs.rawValue - rhs)
        result.normalize()
        return result
    }
    static func - (lhs: Self, rhs: Int) -> Self {
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    static func - <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    static func - <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    static func -= (lhs: inout Self, rhs: Self) {
        lhs.rawValue -= rhs.rawValue
        lhs.normalize()
    }
    static func -= (lhs: inout Self, rhs: Double) {
        lhs.rawValue -= rhs
        lhs.normalize()
    }
    static func -= (lhs: inout Self, rhs: Int) {
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    static func -= <T: BinaryInteger>(lhs: inout Self, rhs: T){
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    static func -= <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        lhs.rawValue -= lhs.rawValue + Double(rhs)
        lhs.normalize()
    }
    static func * (lhs: Self, rhs: Self) -> Self { Self(lhs.rawValue * rhs.rawValue) }
    static func * (lhs: Self, rhs: Double) -> Self { Self(lhs.rawValue * rhs) }
    static func * (lhs: Self, rhs: Int) -> Self { Self(lhs.rawValue * Double(rhs)) }
    static func * <T: BinaryInteger>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue * Double(rhs)) }
    static func * <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue * Double(rhs)) }
    static func / (lhs: Self, rhs: Self) -> Self { Self(lhs.rawValue / rhs.rawValue) }
    static func / (lhs: Self, rhs: Double) -> Self { Self(lhs.rawValue / rhs) }
    static func / (lhs: Self, rhs: Int) -> Self { Self(lhs.rawValue / Double(rhs)) }
    static func / <T: BinaryInteger>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue / Double(rhs)) }
    static func / <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue / Double(rhs)) }
    static func == (lhs: Self, rhs: Self) -> Bool {
        let tolerance = Self.tolerance
        return abs(lhs.rawValue - rhs.rawValue) <= tolerance
    }
    static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue}
    static func <= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue <= rhs.rawValue }
    static func > (lhs: Self, rhs: Self) -> Bool { lhs.rawValue > rhs.rawValue }
    static func >= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue >= rhs.rawValue }
    
    prefix static func - (operand: Self) -> Self { Self(-operand.rawValue) }
}

public extension Anglable {
    init<T: Anglable>(_ angle: T) {
        self.init(angle._convert(to: Self.self).rawValue)
    }
    
    /// Converts the current angle to the specified `AngleType`.
    /// - Parameter type: The target `AngleType` to convert to.
    /// - Returns: An instance conforming to `Anglable` representing the converted angle.
    func convertTo(_ type: AngleType) -> any Anglable {
        switch type {
        case .degrees:     return Degrees(self._convert(to: Degrees.self))
        case .radians:     return Radians(self._convert(to: Radians.self))
        case .gradians:    return Gradians(self._convert(to: Gradians.self))
        case .revolutions: return Revolutions(self._convert(to: Revolutions.self))
        case .arcMinutes:  return ArcMinutes(self._convert(to: ArcMinutes.self))
        case .arcSeconds:  return ArcSeconds(self._convert(to: ArcSeconds.self))
        }
    }
    
    private func _convert<T: Anglable>(to: T.Type) -> T {
        let valueInTargetUnits = self.rawValue * (T.normalizationValue / Self.normalizationValue)
        return T(valueInTargetUnits)
    }
    
    static func + <T: Anglable>(lhs: Self, rhs: T) -> Self {
        let rhsConverted = rhs._convert(to: Self.self)
        var result = Self(lhs.rawValue + rhsConverted.rawValue)
        result.normalize()
        return result
    }
    static func += <T: Anglable>(lhs: inout Self, rhs: T) {
        let rhsConverted = rhs._convert(to: Self.self)
        lhs.rawValue += rhsConverted.rawValue
        lhs.normalize()
    }
    static func - <T: Anglable>(lhs: Self, rhs: T) -> Self {
        let rhsConverted = rhs._convert(to: Self.self)
        var result = Self(lhs.rawValue - rhsConverted.rawValue)
        result.normalize()
        return result
    }
    static func -= <T: Anglable>(lhs: inout Self, rhs: T) {
        let rhsConverted = rhs._convert(to: Self.self)
        lhs.rawValue -= rhsConverted.rawValue
        lhs.normalize()
    }
    static func * <T: Anglable>(lhs: Self, rhs: T) -> Self {
        let rhsConverted = rhs._convert(to: Self.self)
        return Self(lhs.rawValue * rhsConverted.rawValue)
    }
    static func / <T: Anglable>(lhs: Self, rhs: T) -> Self {
        let rhsConverted = rhs._convert(to: Self.self)
        return Self(lhs.rawValue / rhsConverted.rawValue)
    }
    static func == <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let tolerance = Self.tolerance
        let rhsConverted = rhs._convert(to: Self.self)
        return abs(lhs.rawValue - rhsConverted.rawValue) <= tolerance
    }
    static func < <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue < rhsConverted.rawValue
    }
    static func <= <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let tolerance = Self.tolerance
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue <= rhsConverted.rawValue + tolerance
    }
    static func > <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue > rhsConverted.rawValue
    }
    static func >= <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let tolerance = Self.tolerance
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue >= rhsConverted.rawValue - tolerance
    }
}

public extension Anglable {
    /// - Returns: the opposite angle of the current angle.
    func opposite() -> Self {
        let halfCircle = Self.normalizationValue / 2  // For degrees this is 180, for radians this is π, etc.
        
        // Normalize the result to ensure it's within the valid range for the given angle unit
        var oppositeAngle = Self(self.rawValue + halfCircle)
        oppositeAngle.normalize()
        return oppositeAngle
    }
    
   /// Calculates the length of the adjacent side given a hypotenuse and an angle.
   ///
   /// - Parameter hypotenuse: The length of the hypotenuse.
   /// - Returns: The length of the adjacent side.
    func adjacent(to hypotenuse: Double) -> Double {
        return hypotenuse * cos(self.rawValue)
    }
}

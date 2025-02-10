import Foundation

// MARK:- AngleType Protocol

/// A protocol that defines a type that can represent an angle.
public protocol Anglable: Codable, Hashable, Equatable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, CustomStringConvertible, Sendable {
    var rawValue: Double { get set }
    
    /// Initializes an `Anglable` instance with a raw value.
    /// - Parameter rawValue: The raw value of the angle in degrees.
    init(_ rawValue: Double)
    
    /// The normalization value used to normalize the angle.
    static var normalizationValue: Double { get }
    
    /// Normalizes the angle to a value between 0 and the normalization value.
    mutating func normalize()
    
    /// Returns a normalized version of the angle.
    /// - Returns: A normalized version of the angle.
    func normalized() -> Self
    
    /// Converts the angle to a `Measurement<UnitAngle>`.
    /// - Returns: A `Measurement<UnitAngle>` representing the angle.
    func toMeasurement() -> Measurement<UnitAngle>
    
    /// Initializes an `Anglable` instance from another `Anglable` type.
    /// - Parameter angle: The angle to convert.
    init<T: Anglable>(_ angle: T)
}

extension Anglable {
    /// Normalizes the angle by a specified value.
    ///
    /// - Parameter value: The value to normalize the angle by.
    public mutating func normalize(by value: Double) {
        guard rawValue.isFinite else { return }
        self.rawValue = rawValue.remainder(dividingBy: value)
        if rawValue < 0.0 { rawValue += value }
    }
    
    /// Returns a normalized version of the angle by a specified value.
    ///
    /// - Parameter value: The value to normalize the angle by.
    /// - Returns: A normalized version of the angle.
    public func normalized(by value: Double) -> Self {
        var angle = self
        angle.normalize(by: value)
        return angle
    }
    
    /// Normalizes the angle using the `normalizationValue`.
    public mutating func normalize() {
        normalize(by: Self.normalizationValue)
    }
    
    /// Returns a normalized version of the angle using the `normalizationValue`.
    ///
    /// - Returns: A normalized version of the angle.
    public func normalized() -> Self {
        return normalized(by: Self.normalizationValue)
    }
}

public extension Anglable {
    /// The tolerance value used for equality comparisons.
    static var tolerance: Double { 1e-12 }
    
    /// String representation of the angle.
    var description: String {
        return "\(rawValue)"
    }

    /// Initializes an `Anglable` instance with a default value of 0.0.
    init() {
        self.init(0.0)
    }
    
    /// A static property representing a zero angle.
    static var zero: Self {
        .init()
    }
    
    /// Initializes an `Anglable` instance from a floating-point literal.
    ///
    /// - Parameter value: The floating-point value.
    init(floatLiteral value: Double) {
        self.init(value)
    }
    
    /// Initializes an `Anglable` instance from an integer literal.
    ///
    /// - Parameter value: The integer value.
    init(integerLiteral value: Int) {
        self.init(Double(value))
    }
    
    /// Initializes an `Anglable` instance from a binary integer.
    ///
    /// - Parameter value: The binary integer value.
    init<T: BinaryInteger>(_ value: T) {
        self.init(Double(value))
    }
    
    /// Initializes an `Anglable` instance from a binary floating-point value.
    ///
    /// - Parameter value: The binary floating-point value.
    init<T: BinaryFloatingPoint>(_ value: T) {
        self.init(Double(value))
    }
    
    /// Adds two `Anglable` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The sum of the two angles, normalized.
    static func + (lhs: Self, rhs: Self) -> Self {
        var result = Self(lhs.rawValue + rhs.rawValue)
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance and a `Double`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The sum of the angle and the value, normalized.
    static func + (lhs: Self, rhs: Double) -> Self {
        var result = Self(lhs.rawValue + rhs)
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance and an `Int`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The sum of the angle and the value, normalized.
    static func + (lhs: Self, rhs: Int) -> Self {
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance and a binary integer.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The sum of the angle and the value, normalized.
    static func + <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance and a binary floating-point value.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The sum of the angle and the value, normalized.
    static func + <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance to another `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    static func += (lhs: inout Self, rhs: Self) {
        lhs.rawValue += rhs.rawValue
        lhs.normalize()
    }
    
    /// Adds a `Double` to an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += (lhs: inout Self, rhs: Double) {
        lhs.rawValue += rhs
        lhs.normalize()
    }
    
    /// Adds an `Int` to an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += (lhs: inout Self, rhs: Int) {
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    
    /// Adds an `Int` to an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    static func += <T: BinaryInteger>(lhs: inout Self, rhs: T){
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    
    /// Adds a binary floating-point value to an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        lhs.rawValue += lhs.rawValue + Double(rhs)
        lhs.normalize()
    }
    
    /// Subtracts two `Anglable` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The difference between the two angles, normalized.
    static func - (lhs: Self, rhs: Self) -> Self {
        var result = Self(lhs.rawValue - rhs.rawValue)
        result.normalize()
        return result
    }
    
    /// Subtracts a `Double` from an `Anglable` instance.
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The difference between the angle and the value, normalized.
    static func - (lhs: Self, rhs: Double) -> Self {
        var result = Self(lhs.rawValue - rhs)
        result.normalize()
        return result
    }
    
    /// Subtracts an `Int` from an `Anglable` instance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The difference between the angle and the value, normalized.
    static func - (lhs: Self, rhs: Int) -> Self {
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    
    /// Subtracts a binary integer from an `Anglable` instance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The difference between the angle and the value, normalized.
    static func - <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    
    /// Subtracts a binary floating-point value from an `Anglable` instance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The difference between the angle and the value, normalized.
    static func - <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    
    /// Subtracts an `Anglable` instance from another `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    static func -= (lhs: inout Self, rhs: Self) {
        lhs.rawValue -= rhs.rawValue
        lhs.normalize()
    }
    
    /// Subtracts a `Double` from an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= (lhs: inout Self, rhs: Double) {
        lhs.rawValue -= rhs
        lhs.normalize()
    }
    
    /// Subtracts an `Int` from an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= (lhs: inout Self, rhs: Int) {
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    
    /// Subtracts a binary integer from an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= <T: BinaryInteger>(lhs: inout Self, rhs: T){
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    
    /// Subtracts a binary floating-point value from an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        lhs.rawValue -= lhs.rawValue + Double(rhs)
        lhs.normalize()
    }
    
    /// Multiplies two `Anglable` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The product of the two angles.
    static func * (lhs: Self, rhs: Self) -> Self { Self(lhs.rawValue * rhs.rawValue) }
    
    /// Multiplies an `Anglable` instance by a `Double`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * (lhs: Self, rhs: Double) -> Self { Self(lhs.rawValue * rhs) }
    
    /// Multiplies an `Anglable` instance by an `Int`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * (lhs: Self, rhs: Int) -> Self { Self(lhs.rawValue * Double(rhs)) }
    
    /// Multiplies an `Anglable` instance by a binary integer.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * <T: BinaryInteger>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue * Double(rhs)) }
    
    /// Multiplies an `Anglable` instance by a binary floating-point value.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue * Double(rhs)) }
    
    /// Divides two `Anglable` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The quotient of the two angles.
    static func / (lhs: Self, rhs: Self) -> Self { Self(lhs.rawValue / rhs.rawValue) }
    
    /// Divides an `Anglable` instance by a `Double`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value.
    static func / (lhs: Self, rhs: Double) -> Self { Self(lhs.rawValue / rhs) }
    
    /// Divides an `Anglable` instance by an `Int`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value.
    static func / (lhs: Self, rhs: Int) -> Self { Self(lhs.rawValue / Double(rhs)) }
    
    /// Divides an `Anglable` instance by a binary integer.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value.
    static func / <T: BinaryInteger>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue / Double(rhs)) }
    
    /// Divides an `Anglable` instance by a binary floating-point value.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value.
    static func / <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue / Double(rhs)) }
    
    /// Compares two `Anglable` instances for equality.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the angles are equal within the tolerance, otherwise `false`.
    static func == (lhs: Self, rhs: Self) -> Bool { abs(lhs.rawValue - rhs.rawValue) <= Self.tolerance }
    
    /// Compares two `Anglable` instances to determine if the left-hand side is less than the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the left-hand side is less than the right-hand side, otherwise `false`.
    static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue}
    
    /// Compares two `Anglable` instances to determine if the left-hand side is less than or equal to the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the left-hand side is less than or equal to the right-hand side, otherwise `false`.
    static func <= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue <= rhs.rawValue }
    
    /// Compares two `Anglable` instances to determine if the left-hand side is greater than the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the left-hand side is greater than the right-hand side, otherwise `false`.
    static func > (lhs: Self, rhs: Self) -> Bool { lhs.rawValue > rhs.rawValue }
    
    /// Compares two `Anglable` instances to determine if the left-hand side is greater than or equal to the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the left-hand side is greater than or equal to the right-hand side, otherwise `false`.
    static func >= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue >= rhs.rawValue }
    
    /// Negates an `Anglable` instance.
    ///
    /// - Parameter operand: The angle to negate.
    /// - Returns: A new `Anglable` instance with the negated value.
    prefix static func - (operand: Self) -> Self { Self(-operand.rawValue) }
}

public extension Anglable {
    /// Converts the current angle to another `Anglable` type.
    ///
    /// - Parameter angle: The angle to convert.
    init<T: Anglable>(_ angle: T) {
        self.init(angle._convert(to: Self.self).rawValue)
    }
    
    /// Converts the current angle to the specified `AngleType`.
    ///
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
        if Self.self == T.self {
            return self as! T
        }
        
        let valueInTargetUnits = self.rawValue * (T.normalizationValue / Self.normalizationValue)
        return T(valueInTargetUnits)
    }
    
    /// Performs arithmetic addition on two `Anglable` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: A new `Anglable` instance representing the sum.
    static func + <T: Anglable>(lhs: Self, rhs: T) -> Self {
        let rhsConverted = rhs._convert(to: Self.self)
        var result = Self(lhs.rawValue + rhsConverted.rawValue)
        result.normalize()
        return result
    }
    
    /// Adds another `Anglable` value to this instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle to modify.
    ///   - rhs: The right-hand side angle to add.
    static func += <T: Anglable>(lhs: inout Self, rhs: T) {
        let rhsConverted = rhs._convert(to: Self.self)
        lhs.rawValue += rhsConverted.rawValue
        lhs.normalize()
    }
    
    /// Performs arithmetic subtraction on two `Anglable` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: A new `Anglable` instance representing the difference.
    static func - <T: Anglable>(lhs: Self, rhs: T) -> Self {
        let rhsConverted = rhs._convert(to: Self.self)
        var result = Self(lhs.rawValue - rhsConverted.rawValue)
        result.normalize()
        return result
    }

    /// Subtracts another `Anglable` value from this instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle to modify.
    ///   - rhs: The right-hand side angle to subtract.
    static func -= <T: Anglable>(lhs: inout Self, rhs: T) {
        let rhsConverted = rhs._convert(to: Self.self)
        lhs.rawValue -= rhsConverted.rawValue
        lhs.normalize()
    }
    
    /// Multiplies two `Anglable` values.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to multiply.
    /// - Returns: A new `Anglable` instance representing the product.
    static func * <T: Anglable>(lhs: Self, rhs: T) -> Self {
        let rhsConverted = rhs._convert(to: Self.self)
        return Self(lhs.rawValue * rhsConverted.rawValue)
    }
    
    /// Divides an `Anglable` value by another `Anglable` value.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to divide by.
    /// - Returns: A new `Anglable` instance representing the quotient.
    static func / <T: Anglable>(lhs: Self, rhs: T) -> Self {
        let rhsConverted = rhs._convert(to: Self.self)
        return Self(lhs.rawValue / rhsConverted.rawValue)
    }
    
    /// Compares two `Anglable` values for equality within a tolerance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if the angles are equal within the defined tolerance, otherwise `false`.
    static func == <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return abs(lhs.rawValue - rhsConverted.rawValue) <= Self.tolerance
    }
    
    /// Determines whether the left-hand side `Anglable` value is less than the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is less than `rhs`, otherwise `false`.
    static func < <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue < rhsConverted.rawValue
    }
    
    /// Determines whether the left-hand side `Anglable` value is less than or equal to the right-hand side within a tolerance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is less than or equal to `rhs` within the defined tolerance, otherwise `false`.
    static func <= <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue <= rhsConverted.rawValue + Self.tolerance
    }
    
    /// Determines whether the left-hand side `Anglable` value is greater than the right-hand side.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is greater than `rhs`, otherwise `false`.
    static func > <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue > rhsConverted.rawValue
    }
    
    /// Determines whether the left-hand side `Anglable` value is greater than or equal to the right-hand side within a tolerance.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is greater than or equal to `rhs` within the defined tolerance, otherwise `false`.
    static func >= <T: Anglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue >= rhsConverted.rawValue - Self.tolerance
    }
}

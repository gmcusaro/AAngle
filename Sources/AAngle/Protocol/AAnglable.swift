//
// AAnglable.swift
// AAngle
//
// Created by Giovanni Maria Cusaro on 14/02/2025 Copyright 2025
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

// MARK:- AngleType Protocol

/// A protocol that defines a type that can represent an angle.
public protocol AAnglable: Codable, Hashable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, CustomStringConvertible, CustomDebugStringConvertible, Sendable {
    /// The raw value of the angle.
    var rawValue: Double { get set }
    
    /// The tolerance used for equality comparisons for this specific instance.
    var tolerance: Double { get set }
    
    /// Initializes an `Anglable` instance with a raw value.
    ///
    /// - Parameter rawValue: The raw value of the angle in degrees.
    init(_ rawValue: Double)
    
    /// The normalization value used to normalize the angle.
    static var normalizationValue: Double { get }
    
    /// The *default* tolerance value used if no instance-specific tolerance is set,
    /// or as a basis for initialization.
    static var defaultTolerance: Double { get }
    
    /// Normalizes the angle to a value between 0 and the normalization value.
    mutating func normalize()
    
    /// Returns a normalized version of the angle.
    ///
    /// - Returns: A normalized version of the angle.
    func normalized() -> Self
    
    /// Converts the angle to a `Measurement<UnitAngle>`.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle.
    func toMeasurement() -> Measurement<UnitAngle>
    
    /// Initializes an `Anglable` instance from another `Anglable` type.
    ///
    /// - Parameter angle: The angle to convert.
    init<T: AAnglable>(_ angle: T)
}

extension AAnglable {
    /// Normalizes the angle by a specified value. Handles `Double.nan` by returning without modifying the value.
    ///
    /// - Parameter value: The value to normalize the angle by.
    @inlinable
    public mutating func normalize(by value: Double) {
        guard rawValue.isFinite, value.isFinite, value != 0 else { return }
        self.rawValue = fmod(rawValue, value)
        if rawValue < 0.0 { rawValue += value }
    }
    
    /// Returns a normalized version of the angle by a specified value.
    ///
    /// - Parameter value: The value to normalize the angle by.
    /// - Returns: A normalized version of the angle.
    @inlinable
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
    @inlinable
    public func normalized() -> Self {
        return normalized(by: Self.normalizationValue)
    }
}

public extension AAnglable {
    ///  The *default* tolerance value
    static var defaultTolerance: Double { 1e-12 }
    
    /// String representation of the angle.
    @inlinable
    var description: String {
        rawValue.descriptiveString
    }
    
    /// String to debug of the angle. Handles `Double.nan` and infinity.
    @inlinable
    var debugDescription: String {
#if DEBUG
        let prefix = "Angle(\(type(of: self))): "
        if rawValue.isNaN { return prefix + "rawValue = NaN" }
        if rawValue.isInfinite { return prefix + "rawValue = \(rawValue < 0 ? "-Inf" : "+Inf")" }
        return prefix + "rawValue = \(rawValue), normalized = \(normalized().rawValue)"
#else
        return String(describing: self)
#endif
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
    
    /// Adds two `Anglable` instances. Handles `Double.nan` and infinity.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The sum of the two angles, normalized.
    static func + (lhs: Self, rhs: Self) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue + rhs.rawValue)
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance and a `Double`. Handles `Double.nan` and infinity.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The sum of the angle and the value, normalized.
    static func + (lhs: Self, rhs: Double) -> Self {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue + rhs)
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance and an `Int`. Handles `Double.nan` and infinity.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The sum of the angle and the value, normalized.
    static func + (lhs: Self, rhs: Int) -> Self {
        guard lhs.rawValue.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance and a binary integer. Handles `Double.nan` and infinity.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The sum of the angle and the value, normalized.
    static func + <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance and a binary floating-point value. Handles `Double.nan` and infinity.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The sum of the angle and the value, normalized.
    static func + <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    
    /// Adds an `Anglable` instance to another `Anglable` instance in place. Handles `Double.nan` by doing nothing.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    static func += (lhs: inout Self, rhs: Self) {
        guard lhs.rawValue.isFinite && rhs.rawValue.isFinite else { return }
        lhs.rawValue += rhs.rawValue
        lhs.normalize()
    }
    
    /// Adds a `Double` to an `Anglable` instance in place. Handles `Double.nan` by doing nothing.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += (lhs: inout Self, rhs: Double) {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return }
        lhs.rawValue += rhs
        lhs.normalize()
    }
    
    /// Adds an `Int` to an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += (lhs: inout Self, rhs: Int) {
        guard lhs.rawValue.isFinite else { return }
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    
    /// Adds an `Int` to an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    static func += <T: BinaryInteger>(lhs: inout Self, rhs: T){
        guard lhs.rawValue.isFinite else { return }
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    
    /// Adds a binary floating-point value to an `Anglable` instance in place. Handles `Double.nan` by doing nothing.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return }
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    
    /// Subtracts two `Anglable` instances. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The difference between the two angles, normalized.
    static func - (lhs: Self, rhs: Self) -> Self {
        guard lhs.rawValue.isFinite && rhs.rawValue.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue - rhs.rawValue)
        result.normalize()
        return result
    }
    
    /// Subtracts a `Double` from an `Anglable` instance. Handles `Double.nan`.
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The difference between the angle and the value, normalized.
    static func - (lhs: Self, rhs: Double) -> Self {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue - rhs)
        result.normalize()
        return result
    }
    
    /// Subtracts an `Int` from an `Anglable` instance. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The difference between the angle and the value, normalized.
    static func - (lhs: Self, rhs: Int) -> Self {
        guard lhs.rawValue.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    
    /// Subtracts a binary integer from an `Anglable` instance. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The difference between the angle and the value, normalized.
    static func - <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    
    /// Subtracts a binary floating-point value from an `Anglable` instance. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The difference between the angle and the value, normalized.
    static func - <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return Self(.nan) }
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    
    /// Subtracts an `Anglable` instance from another `Anglable` instance in place. Handles `Double.nan` by doing nothing.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    static func -= (lhs: inout Self, rhs: Self) {
        guard lhs.rawValue.isFinite && rhs.rawValue.isFinite else { return }
        lhs.rawValue -= rhs.rawValue
        lhs.normalize()
    }
    
    /// Subtracts a `Double` from an `Anglable` instance in place. Handles `Double.nan` by doing nothing.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= (lhs: inout Self, rhs: Double) {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return }
        lhs.rawValue -= rhs
        lhs.normalize()
    }
    
    /// Subtracts an `Int` from an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= (lhs: inout Self, rhs: Int) {
        guard lhs.rawValue.isFinite else { return }
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    
    /// Subtracts a binary integer from an `Anglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= <T: BinaryInteger>(lhs: inout Self, rhs: T){
        guard lhs.rawValue.isFinite else { return }
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    
    /// Subtracts a binary floating-point value from an `Anglable` instance in place. Handles `Double.nan` by doing nothing.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return }
        lhs.rawValue -= lhs.rawValue + Double(rhs)
        lhs.normalize()
    }
    
    /// Multiplies two `Anglable` instances. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The product of the two angles.
    static func * (lhs: Self, rhs: Self) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * rhs.rawValue)
    }
    
    /// Multiplies an `Anglable` instance by a `Double`. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * (lhs: Self, rhs: Double) -> Self {
        guard lhs.rawValue.isFinite, rhs.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * rhs)
    }
    
    /// Multiplies an `Anglable` instance by an `Int`. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * (lhs: Self, rhs: Int) -> Self {
        guard lhs.rawValue.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * Double(rhs))
    }
    
    /// Multiplies an `Anglable` instance by a binary integer. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * Double(rhs))
    }
    
    /// Multiplies an `Anglable` instance by a binary floating-point value. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * Double(rhs))
    }
    
    /// Divides two `Anglable` instances. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The quotient of the two angles.
    static func / (lhs: Self, rhs: Self) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue / rhs.rawValue)
    }
    
    /// Divides an `Anglable` instance by a `Double`. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value.
    static func / (lhs: Self, rhs: Double) -> Self {
        guard lhs.rawValue.isFinite, rhs.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue / rhs)
    }
    
    /// Divides an `Anglable` instance by an `Int`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value.
    static func / (lhs: Self, rhs: Int) -> Self { Self(lhs.rawValue / Double(rhs)) }
    
    /// Divides an `Anglable` instance by a binary integer. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value.
    static func / <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue / Double(rhs))
    }
    
    /// Divides an `Anglable` instance by a binary floating-point value. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value.
    static func / <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue / Double(rhs))
    }
    
    /// Compares two `Anglable` instances for equality. Handles `Double.nan`. Handles `Double.nan` correctly.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the angles are equal within the tolerance, otherwise `false`.
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.rawValue.isNaN || rhs.rawValue.isNaN {
            return false // NaN is never equal to anything, including itself.
        }
        // Use the maximum of the two tolerances for comparison
        let effectiveTolerance = max(lhs.tolerance, rhs.tolerance)
        return abs(lhs.rawValue - rhs.rawValue) <= effectiveTolerance
    }
    
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
    
    /// Negates an `Anglable` instance. Handles `Double.nan`.
    ///
    /// - Parameter operand: The angle to negate.
    /// - Returns: A new `Anglable` instance with the negated value.
    prefix static func - (operand: Self) -> Self {
        guard operand.rawValue.isFinite else { return Self(.nan) }
        return Self(-operand.rawValue)
    }
}

public extension AAnglable {
    /// Converts the current angle to another `Anglable` type.
    ///
    /// - Parameter angle: The angle to convert.
    init<T: AAnglable>(_ angle: T) {
        self.init(angle._convert(to: Self.self).rawValue)
    }
    
    /// Converts the current angle to the specified `AngleType`. Handles `Double.nan`.
    ///
    /// - Parameter type: The target `AngleType` to convert to.
    /// - Returns: An instance conforming to `Anglable` representing the converted angle.
    func convert(to type: AAngleType) -> any AAnglable {
        switch type {
        case .degrees:     return Degrees(self._convert(to: Degrees.self))
        case .radians:     return Radians(self._convert(to: Radians.self))
        case .gradians:    return Gradians(self._convert(to: Gradians.self))
        case .revolutions: return Revolutions(self._convert(to: Revolutions.self))
        case .arcMinutes:  return ArcMinutes(self._convert(to: ArcMinutes.self))
        case .arcSeconds:  return ArcSeconds(self._convert(to: ArcSeconds.self))
        }
    }
    
    private func _convert<T: AAnglable>(to: T.Type) -> T {
        if Self.self == T.self {
            return self as! T
        }
        
        guard self.rawValue.isFinite else {
             return T(.nan)
        }
        
        let valueInTargetUnits = self.rawValue * (T.normalizationValue / Self.normalizationValue)
        return T(valueInTargetUnits)
    }
    
    /// Performs arithmetic addition on two `Anglable` instances. Handles `Double.nan` and infinity.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: A new `Anglable` instance representing the sum.
    static func + <T: AAnglable>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        let rhsConverted = rhs._convert(to: Self.self)
        var result = Self(lhs.rawValue + rhsConverted.rawValue)
        result.normalize()
        return result
    }
    
    /// Adds another `Anglable` value to this instance in place. Handles `Double.nan` by doing nothing.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle to modify.
    ///   - rhs: The right-hand side angle to add.
    static func += <T: AAnglable>(lhs: inout Self, rhs: T) {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return }
        let rhsConverted = rhs._convert(to: Self.self)
        lhs.rawValue += rhsConverted.rawValue
        lhs.normalize()
    }
    
    /// Performs arithmetic subtraction on two `Anglable` instances. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: A new `Anglable` instance representing the difference.
    static func - <T: AAnglable>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        let rhsConverted = rhs._convert(to: Self.self)
        var result = Self(lhs.rawValue - rhsConverted.rawValue)
        result.normalize()
        return result
    }
    
    /// Subtracts another `Anglable` value from this instance in place. Handles `Double.nan` by doing nothing.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle to modify.
    ///   - rhs: The right-hand side angle to subtract.
    static func -= <T: AAnglable>(lhs: inout Self, rhs: T) {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return }
        let rhsConverted = rhs._convert(to: Self.self)
        lhs.rawValue -= rhsConverted.rawValue
        lhs.normalize()
    }
    
    /// Multiplies two `Anglable` values. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to multiply.
    /// - Returns: A new `Anglable` instance representing the product.
    static func * <T: AAnglable>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        let rhsConverted = rhs._convert(to: Self.self)
        return Self(lhs.rawValue * rhsConverted.rawValue)
    }
    
    /// Divides an `Anglable` value by another `Anglable` value. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to divide by.
    /// - Returns: A new `Anglable` instance representing the quotient.
    static func / <T: AAnglable>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        let rhsConverted = rhs._convert(to: Self.self)
        return Self(lhs.rawValue / rhsConverted.rawValue)
    }
    
    /// Compares two `Anglable` values for equality within a tolerance. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if the angles are equal within the defined tolerance, otherwise `false`.
    static func == <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        if lhs.rawValue.isNaN || rhs.rawValue.isNaN {
            return false
        }
        // Use the maximum of the two tolerances for comparison
        let effectiveTolerance = max(lhs.tolerance, rhs.tolerance)
        let rhsConverted = rhs._convert(to: Self.self)
        return abs(lhs.rawValue - rhsConverted.rawValue) <= effectiveTolerance
    }
    
    /// Determines whether the left-hand side `Anglable` value is less than the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is less than `rhs`, otherwise `false`.
    static func < <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue < rhsConverted.rawValue
    }
    
    /// Determines whether the left-hand side `Anglable` value is less than or equal to the right-hand side within a tolerance. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is less than or equal to `rhs` within the defined tolerance, otherwise `false`.
    static func <= <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        if lhs.rawValue.isNaN || rhs.rawValue.isNaN {
            return false
        }
        // Use the maximum of the two tolerances for comparison
        let effectiveTolerance = max(lhs.tolerance, rhs.tolerance)
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue <= rhsConverted.rawValue + effectiveTolerance
    }
    
    /// Determines whether the left-hand side `Anglable` value is greater than the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is greater than `rhs`, otherwise `false`.
    static func > <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue > rhsConverted.rawValue
    }
    
    /// Determines whether the left-hand side `Anglable` value is greater than or equal to the right-hand side within a tolerance. Handles `Double.nan`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is greater than or equal to `rhs` within the defined tolerance, otherwise `false`.
    static func >= <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        if lhs.rawValue.isNaN || rhs.rawValue.isNaN {
           return false
        }
        // Use the maximum of the two tolerances for comparison
        let effectiveTolerance = max(lhs.tolerance, rhs.tolerance)
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue >= rhsConverted.rawValue - effectiveTolerance
    }
}

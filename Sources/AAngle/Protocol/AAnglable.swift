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
    
    /// Initializes an `AAnglable` instance with a raw value.
    ///
    /// - Parameter rawValue: The raw value of the angle in the conforming unit.
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
    
    /// Initializes an `AAnglable` instance from another `AAnglable` type.
    ///
    /// - Parameter angle: The angle to convert.
    init<T: AAnglable>(_ angle: T)
}

extension AAnglable {
    /// Normalizes the angle by a specified positive value.
    ///
    /// Returns without modification when either operand is non-finite or when `value <= 0`.
    ///
    /// - Parameter value: The value to normalize the angle by.
    @inlinable
    public mutating func normalize(by value: Double) {
        guard rawValue.isFinite, value.isFinite, value > 0.0 else { return }
        if rawValue >= 0.0, rawValue < value { return }
        
        rawValue = rawValue.truncatingRemainder(dividingBy: value)
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

    /// Sanitizes tolerance values so comparisons stay predictable.
    ///
    /// - Parameter tolerance: The candidate tolerance value.
    /// - Returns: A finite non-negative tolerance, clamped to at least `defaultTolerance`.
    static func sanitizedTolerance(_ tolerance: Double) -> Double {
        guard tolerance.isFinite, tolerance >= 0 else { return Self.defaultTolerance }
        return Swift.max(tolerance, Self.defaultTolerance)
    }
    
    /// String representation of the angle.
    @inlinable
    var description: String {
        rawValue.descriptiveString
    }
    
    /// String to debug of the angle. Handles `NaN` and infinity explicitly.
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
    
    /// Initializes an `AAnglable` instance with a default value of 0.0.
    init() {
        self.init(0.0)
    }
    
    /// A static property representing a zero angle.
    static var zero: Self {
        .init()
    }
    
    /// Initializes an `AAnglable` instance from a floating-point literal.
    ///
    /// - Parameter value: The floating-point value.
    init(floatLiteral value: Double) {
        self.init(value)
    }
    
    /// Initializes an `AAnglable` instance from an integer literal.
    ///
    /// - Parameter value: The integer value.
    init(integerLiteral value: Int) {
        self.init(Double(value))
    }
    
    /// Initializes an `AAnglable` instance from a binary integer.
    ///
    /// - Parameter value: The binary integer value.
    init<T: BinaryInteger>(_ value: T) {
        self.init(Double(value))
    }
    
    /// Initializes an `AAnglable` instance from a binary floating-point value.
    ///
    /// - Parameter value: The binary floating-point value.
    init<T: BinaryFloatingPoint>(_ value: T) {
        self.init(Double(value))
    }
    
    /// Converts any `AAnglable` value into the current conforming type.
    ///
    /// - Parameter angle: The source angle value to convert.
    init<T: AAnglable>(_ angle: T) {
        guard
            Self.normalizationValue.isFinite,
            T.normalizationValue.isFinite,
            T.normalizationValue != 0
        else {
            self.init(.nan)
            self.tolerance = Self.defaultTolerance
            return
        }

        let scale = Self.normalizationValue / T.normalizationValue
        if angle.rawValue.isFinite {
            self.init(angle.rawValue * scale)
        } else {
            self.init(.nan)
        }

        let convertedTolerance = T.sanitizedTolerance(angle.tolerance) * abs(scale)
        self.tolerance = Swift.max(Self.defaultTolerance, convertedTolerance)
    }
    
    /// Converts the current angle to the specified `AAngleType`.
    ///
    /// - Parameter type: The target `AAngleType` to convert to.
    /// - Returns: An instance conforming to `AAnglable` representing the converted angle.
    func convert(to type: AAngleType) -> any AAnglable {
        return type.initAngle(self)
    }
    
    private func _convert<T: AAnglable>(to: T.Type) -> T {
        if Self.self == T.self {
            return self as! T
        }

        guard
            Self.normalizationValue.isFinite,
            T.normalizationValue.isFinite,
            Self.normalizationValue != 0
        else {
            var invalid = T(.nan)
            invalid.tolerance = T.defaultTolerance
            return invalid
        }

        let scale = T.normalizationValue / Self.normalizationValue
        let scaledTolerance = Self.sanitizedTolerance(self.tolerance) * abs(scale)

        guard self.rawValue.isFinite else {
            var invalid = T(.nan)
            invalid.tolerance = Swift.max(T.defaultTolerance, scaledTolerance)
            return invalid
        }

        var result = T(self.rawValue * scale)
        result.tolerance = Swift.max(T.defaultTolerance, scaledTolerance)
        return result
    }

    /// Converts the current angle to a concrete `AAnglable` type.
    ///
    /// - Parameter to: The destination angle type.
    /// - Returns: The converted angle value in the destination type.
    func converted<T: AAnglable>(to: T.Type) -> T {
        _convert(to: T.self)
    }

    /// Compares two angles using a configurable tolerance.
    ///
    /// - Parameters:
    ///   - other: The angle to compare against.
    ///   - tolerance: An optional custom tolerance. When `nil`, the larger sanitized instance tolerance is used.
    /// - Returns: `true` if the two values differ by no more than the effective tolerance.
    func isApproximatelyEqual<T: AAnglable>(to other: T, tolerance: Double? = nil) -> Bool {
        let otherConverted = other._convert(to: Self.self)
        guard rawValue.isFinite, otherConverted.rawValue.isFinite else { return false }
        let effectiveTolerance = tolerance.map(Self.sanitizedTolerance)
            ?? Swift.max(
                Self.sanitizedTolerance(self.tolerance),
                Self.sanitizedTolerance(otherConverted.tolerance)
            )
        return abs(rawValue - otherConverted.rawValue) <= effectiveTolerance
    }

    /// Compares two angles for circular equivalence (for example, `0°` and `360°`).
    ///
    /// - Parameters:
    ///   - other: The angle to compare against.
    ///   - tolerance: An optional custom tolerance. When `nil`, the larger sanitized instance tolerance is used.
    /// - Returns: `true` when the normalized circular distance is within tolerance.
    func isEquivalent<T: AAnglable>(to other: T, tolerance: Double? = nil) -> Bool {
        guard Self.normalizationValue.isFinite, Self.normalizationValue > 0 else { return false }
        let lhs = self.normalized()
        let rhs = other._convert(to: Self.self).normalized()
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return false }
        let effectiveTolerance = tolerance.map(Self.sanitizedTolerance)
            ?? Swift.max(
                Self.sanitizedTolerance(lhs.tolerance),
                Self.sanitizedTolerance(rhs.tolerance)
            )
        let delta = abs(lhs.rawValue - rhs.rawValue)
        return Swift.min(delta, Self.normalizationValue - delta) <= effectiveTolerance
    }
    
    /// Adds two `AAnglable` instances. Returns `.nan` for non-finite operands.
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
    
    /// Adds an `AAnglable` instance and a `Double`. Returns `.nan` for non-finite operands.
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
    
    /// Adds an `AAnglable` instance and an `Int`. Returns `.nan` for non-finite operands.
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
    
    /// Adds an `AAnglable` instance and a binary integer. Returns `.nan` for non-finite operands.
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
    
    /// Adds an `AAnglable` instance and a binary floating-point value. Returns `.nan` for non-finite operands.
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

    /// Adds a `Double` to an angle with the numeric operand on the left-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side numeric value.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The normalized sum of the numeric value and angle.
    @inlinable
    static func + (lhs: Double, rhs: Self) -> Self {
        rhs + lhs
    }

    /// Adds an `Int` to an angle with the numeric operand on the left-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side numeric value.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The normalized sum of the numeric value and angle.
    @inlinable
    static func + (lhs: Int, rhs: Self) -> Self {
        rhs + lhs
    }

    /// Subtracts an angle from a `Double` with the numeric operand on the left-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side numeric value.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The normalized difference, or `.nan` if `lhs` is non-finite.
    @inlinable
    static func - (lhs: Double, rhs: Self) -> Self {
        guard lhs.isFinite else { return Self(.nan) }
        return Self(lhs) - rhs
    }

    /// Subtracts an angle from an `Int` with the numeric operand on the left-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side numeric value.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The normalized difference.
    @inlinable
    static func - (lhs: Int, rhs: Self) -> Self {
        Self(lhs) - rhs
    }
    
    /// Adds an `AAnglable` instance to another `AAnglable` instance in place. Returns without mutation for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    static func += (lhs: inout Self, rhs: Self) {
        guard lhs.rawValue.isFinite && rhs.rawValue.isFinite else { return }
        lhs.rawValue += rhs.rawValue
        lhs.normalize()
    }
    
    /// Adds a `Double` to an `AAnglable` instance in place. Returns without mutation for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += (lhs: inout Self, rhs: Double) {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return }
        lhs.rawValue += rhs
        lhs.normalize()
    }
    
    /// Adds an `Int` to an `AAnglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += (lhs: inout Self, rhs: Int) {
        guard lhs.rawValue.isFinite else { return }
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    
    /// Adds a binary integer to an `AAnglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += <T: BinaryInteger>(lhs: inout Self, rhs: T){
        guard lhs.rawValue.isFinite else { return }
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    
    /// Adds a binary floating-point value to an `AAnglable` instance in place. Returns without mutation for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func += <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return }
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    
    /// Subtracts two `AAnglable` instances. Returns `.nan` for non-finite operands.
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
    
    /// Subtracts a `Double` from an `AAnglable` instance. Returns `.nan` for non-finite operands.
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
    
    /// Subtracts an `Int` from an `AAnglable` instance. Returns `.nan` for non-finite operands.
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
    
    /// Subtracts a binary integer from an `AAnglable` instance. Returns `.nan` for non-finite operands.
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
    
    /// Subtracts a binary floating-point value from an `AAnglable` instance. Returns `.nan` for non-finite operands.
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
    
    /// Subtracts an `AAnglable` instance from another `AAnglable` instance in place. Returns without mutation for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    static func -= (lhs: inout Self, rhs: Self) {
        guard lhs.rawValue.isFinite && rhs.rawValue.isFinite else { return }
        lhs.rawValue -= rhs.rawValue
        lhs.normalize()
    }
    
    /// Subtracts a `Double` from an `AAnglable` instance in place. Returns without mutation for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= (lhs: inout Self, rhs: Double) {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return }
        lhs.rawValue -= rhs
        lhs.normalize()
    }
    
    /// Subtracts an `Int` from an `AAnglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= (lhs: inout Self, rhs: Int) {
        guard lhs.rawValue.isFinite else { return }
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    
    /// Subtracts a binary integer from an `AAnglable` instance in place.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= <T: BinaryInteger>(lhs: inout Self, rhs: T){
        guard lhs.rawValue.isFinite else { return }
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    
    /// Subtracts a binary floating-point value from an `AAnglable` instance in place. Returns without mutation for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    static func -= <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        guard lhs.rawValue.isFinite && rhs.isFinite else { return }
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    
    /// Multiplies two `AAnglable` instances. Returns `.nan` for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The product of the two angles.
    static func * (lhs: Self, rhs: Self) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * rhs.rawValue)
    }
    
    /// Multiplies an `AAnglable` instance by a `Double`. Returns `.nan` for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * (lhs: Self, rhs: Double) -> Self {
        guard lhs.rawValue.isFinite, rhs.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * rhs)
    }
    
    /// Multiplies an `AAnglable` instance by an `Int`. Returns `.nan` for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * (lhs: Self, rhs: Int) -> Self {
        guard lhs.rawValue.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * Double(rhs))
    }
    
    /// Multiplies an `AAnglable` instance by a binary integer. Returns `.nan` for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * Double(rhs))
    }
    
    /// Multiplies an `AAnglable` instance by a binary floating-point value. Returns `.nan` for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The product of the angle and the value.
    static func * <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs.isFinite else { return Self(.nan) }
        return Self(lhs.rawValue * Double(rhs))
    }
    
    /// Divides two `AAnglable` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: The quotient of the two angles, or `.nan` for non-finite values or division by zero.
    static func / (lhs: Self, rhs: Self) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite, rhs.rawValue != 0 else { return Self(.nan) }
        return Self(lhs.rawValue / rhs.rawValue)
    }
    
    /// Divides an `AAnglable` instance by a `Double`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value, or `.nan` for non-finite values or division by zero.
    static func / (lhs: Self, rhs: Double) -> Self {
        guard lhs.rawValue.isFinite, rhs.isFinite, rhs != 0 else { return Self(.nan) }
        return Self(lhs.rawValue / rhs)
    }
    
    /// Divides an `AAnglable` instance by an `Int`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value, or `.nan` for non-finite values or division by zero.
    static func / (lhs: Self, rhs: Int) -> Self {
        guard lhs.rawValue.isFinite, rhs != 0 else { return Self(.nan) }
        return Self(lhs.rawValue / Double(rhs))
    }
    
    /// Divides an `AAnglable` instance by a binary integer.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value, or `.nan` for non-finite values or division by zero.
    static func / <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs != 0 else { return Self(.nan) }
        return Self(lhs.rawValue / Double(rhs))
    }
    
    /// Divides an `AAnglable` instance by a binary floating-point value.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side value.
    /// - Returns: The quotient of the angle and the value, or `.nan` for non-finite values or division by zero.
    static func / <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite && rhs.isFinite && rhs != 0 else { return Self(.nan) }
        return Self(lhs.rawValue / Double(rhs))
    }
    
    /// Compares two `AAnglable` instances to determine if the left-hand side is less than the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the left-hand side is less than the right-hand side, otherwise `false`.
    static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue}
    
    /// Compares two `AAnglable` instances to determine if the left-hand side is less than or equal to the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the left-hand side is less than or equal to the right-hand side, otherwise `false`.
    static func <= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue <= rhs.rawValue }
    
    /// Compares two `AAnglable` instances to determine if the left-hand side is greater than the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the left-hand side is greater than the right-hand side, otherwise `false`.
    static func > (lhs: Self, rhs: Self) -> Bool { lhs.rawValue > rhs.rawValue }
    
    /// Compares two `AAnglable` instances to determine if the left-hand side is greater than or equal to the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the left-hand side is greater than or equal to the right-hand side, otherwise `false`.
    static func >= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue >= rhs.rawValue }
    
    /// Negates an `AAnglable` instance. Returns `.nan` for non-finite operands.
    ///
    /// - Parameter operand: The angle to negate.
    /// - Returns: A new `AAnglable` instance with the negated value.
    prefix static func - (operand: Self) -> Self {
        guard operand.rawValue.isFinite else { return Self(.nan) }
        return Self(-operand.rawValue)
    }
    
    /// Performs arithmetic addition on two `AAnglable` instances. Returns `.nan` for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: A new `AAnglable` instance representing the sum.
    static func + <T: AAnglable>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        let rhsConverted = rhs._convert(to: Self.self)
        var result = Self(lhs.rawValue + rhsConverted.rawValue)
        result.normalize()
        return result
    }
    
    /// Adds another `AAnglable` value to this instance in place. Returns without mutation for non-finite operands.
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
    
    /// Performs arithmetic subtraction on two `AAnglable` instances. Returns `.nan` for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: A new `AAnglable` instance representing the difference.
    static func - <T: AAnglable>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        let rhsConverted = rhs._convert(to: Self.self)
        var result = Self(lhs.rawValue - rhsConverted.rawValue)
        result.normalize()
        return result
    }
    
    /// Subtracts another `AAnglable` value from this instance in place. Returns without mutation for non-finite operands.
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
    
    /// Multiplies two `AAnglable` values. Returns `.nan` for non-finite operands.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to multiply.
    /// - Returns: A new `AAnglable` instance representing the product.
    static func * <T: AAnglable>(lhs: Self, rhs: T) -> Self {
        guard lhs.rawValue.isFinite, rhs.rawValue.isFinite else { return Self(.nan) }
        let rhsConverted = rhs._convert(to: Self.self)
        return Self(lhs.rawValue * rhsConverted.rawValue)
    }
    
    /// Divides an `AAnglable` value by another `AAnglable` value.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to divide by.
    /// - Returns: A new `AAnglable` instance representing the quotient, or `.nan` for non-finite values or division by zero.
    static func / <T: AAnglable>(lhs: Self, rhs: T) -> Self {
        let rhsConverted = rhs._convert(to: Self.self)
        guard lhs.rawValue.isFinite, rhsConverted.rawValue.isFinite, rhsConverted.rawValue != 0 else { return Self(.nan) }
        return Self(lhs.rawValue / rhsConverted.rawValue)
    }
    
    /// Compares two same-unit angles using instance tolerance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: `true` if the values are approximately equal.
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isApproximatelyEqual(to: rhs)
    }
    
    /// Compares two `AAnglable` values for equality within a tolerance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if the angles are equal within the defined tolerance, otherwise `false`.
    ///   Returns `false` when either value is non-finite.
    static func == <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        lhs.isApproximatelyEqual(to: rhs)
    }
    
    /// Determines whether the left-hand side `AAnglable` value is less than the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is less than `rhs`, otherwise `false`.
    static func < <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue < rhsConverted.rawValue
    }
    
    /// Determines whether the left-hand side `AAnglable` value is less than or equal to the right-hand side within a tolerance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is less than or equal to `rhs` within the defined tolerance, otherwise `false`.
    ///   Returns `false` when either value is non-finite.
    static func <= <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        guard lhs.rawValue.isFinite, rhsConverted.rawValue.isFinite else { return false }
        let effectiveTolerance = Swift.max(
            Self.sanitizedTolerance(lhs.tolerance),
            Self.sanitizedTolerance(rhsConverted.tolerance)
        )
        return lhs.rawValue <= rhsConverted.rawValue + effectiveTolerance
    }
    
    /// Determines whether the left-hand side `AAnglable` value is greater than the right-hand side.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is greater than `rhs`, otherwise `false`.
    static func > <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        return lhs.rawValue > rhsConverted.rawValue
    }
    
    /// Determines whether the left-hand side `AAnglable` value is greater than or equal to the right-hand side within a tolerance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle to compare.
    /// - Returns: `true` if `lhs` is greater than or equal to `rhs` within the defined tolerance, otherwise `false`.
    ///   Returns `false` when either value is non-finite.
    static func >= <T: AAnglable>(lhs: Self, rhs: T) -> Bool {
        let rhsConverted = rhs._convert(to: Self.self)
        guard lhs.rawValue.isFinite, rhsConverted.rawValue.isFinite else { return false }
        let effectiveTolerance = Swift.max(
            Self.sanitizedTolerance(lhs.tolerance),
            Self.sanitizedTolerance(rhsConverted.tolerance)
        )
        return lhs.rawValue >= rhsConverted.rawValue - effectiveTolerance
    }
}

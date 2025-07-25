//
// AngleType.swift
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

public enum AAngleType: String, Codable, Hashable, Sendable {
    case gradians, degrees, radians, revolutions, arcSeconds, arcMinutes
}

public extension AAngleType {
    /// Human-readable description of the angle type.
    @inlinable
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

public extension AAngleType {    
    /// Resolves the corresponding angle type initializer.
    @usableFromInline
    internal var angleInitializer: (Double) -> any AAnglable {
        switch self {
        case .degrees:     return Degrees.init
        case .radians:     return Radians.init
        case .gradians:    return Gradians.init
        case .revolutions: return Revolutions.init
        case .arcMinutes:  return ArcMinutes.init
        case .arcSeconds:  return ArcSeconds.init
        }
    }

    /// Initializes an angle instance using a `Double` value.
    ///
    /// - Parameter value: The value of the angle in the specified `AngleType` unit.
    /// - Returns: An `Anglable` instance representing the angle.
    @inlinable
    func initAngle(_ value: Double) -> any AAnglable {
        return angleInitializer(value)
    }

    /// Initializes an angle instance using a floating-point value.
    ///
    /// - Parameter value: The value of the angle in the specified `AngleType` unit.
    /// - Returns: An `Anglable` instance representing the angle.
    @inlinable
    func initAngle<T: BinaryFloatingPoint>(_ value: T) -> any AAnglable {
        initAngle(Double(value))
    }

    /// Initializes an angle instance using an integer value.
    ///
    /// - Parameter value: The value of the angle in the specified `AngleType` unit.
    /// - Returns: An `Anglable` instance representing the angle.
    @inlinable
    func initAngle<T: BinaryInteger>(_ value: T) -> any AAnglable {
        initAngle(Double(value))
    }

    /// Converts an existing `AAnglable` instance to a new instance of the specified `AAngleType`.
    ///
    /// This method creates a new angle value of the type represented by `self`,
    /// converting from the provided `AAnglable` instance using the native
    /// `init<T: AAnglable>(_:)` protocol initializer. The resulting value will
    /// be equivalent in measure but represented in the unit corresponding to `self`.
    ///
    /// - Parameter value: An existing `AAnglable` instance to convert.
    /// - Returns: A new `AAnglable` instance in the unit type specified by `self`.
    @inlinable    
    func initAngle(_ value: any AAnglable) -> any AAnglable {
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

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

public enum AngleType: String, Codable, Equatable, Hashable {
    case gradians, degrees, radians, revolutions, arcSeconds, arcMinutes
}

public extension AngleType {
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

public extension AngleType {    
    /// Resolves the corresponding angle type initializer.
    @usableFromInline
    internal var angleInitializer: (Double) -> any Anglable {
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
    func initAngle(_ value: Double) -> any Anglable {
        return angleInitializer(value)
    }

    /// Initializes an angle instance using a floating-point value.
    ///
    /// - Parameter value: The value of the angle in the specified `AngleType` unit.
    /// - Returns: An `Anglable` instance representing the angle.
    @inlinable
    func initAngle<T: BinaryFloatingPoint>(_ value: T) -> any Anglable {
        initAngle(Double(value))
    }

    /// Initializes an angle instance using an integer value.
    ///
    /// - Parameter value: The value of the angle in the specified `AngleType` unit.
    /// - Returns: An `Anglable` instance representing the angle.
    @inlinable
    func initAngle<T: BinaryInteger>(_ value: T) -> any Anglable {
        initAngle(Double(value))
    }

    /// Converts an existing `Anglable` instance to the specified `AngleType`.
    ///
    /// - Parameter value: An existing `Anglable` instance to be converted.
    /// - Returns: A new `Anglable` instance in the specified `AngleType` unit.
    @inlinable
    func initAngle(_ value: any Anglable) -> any Anglable {
        angleInitializer(value.rawValue)
    }
}

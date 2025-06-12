//
// Degrees.swift
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

public struct Degrees: Hashable, Codable, Sendable, AAnglable {
    public var rawValue: Double
    public var tolerance: Double
    
    /// Initializes a `Degrees` instance with a raw `Double` value.
    /// 
    /// - Parameter rawValue: The angle in degrees as a `Double`.
    @inlinable
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
        self.tolerance = Self.defaultTolerance
    }
    
    /// The normalization value used for converting and normalizing degrees.
    public static let normalizationValue: Double = 360.0
    
    /// Converts the `Degrees` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `Degrees` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in degrees.
    @inlinable
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .degrees)
    }
}

extension Degrees {
    /// Computes the opposite angle by adding 180 degrees and normalizing.
    ///
    /// - Returns: The opposite angle in degrees.
    @inlinable
    public var opposite: Degrees {
        var oppositeAngle = Degrees(180.0 - self.rawValue)
        oppositeAngle.normalize()
        return oppositeAngle
     }
    
    /// Computes the two adjacent angles by adding and subtracting 90 degrees.
    ///
    /// - Returns: An array containing the two adjacent angles in degrees.
    @inlinable
    public func adjacentAngles() -> [Degrees] {
        let adj1 = (rawValue + 90).truncatingRemainder(dividingBy: Self.normalizationValue)
        let adj2 = (rawValue - 90).truncatingRemainder(dividingBy: Self.normalizationValue)
        
        let normalizedAdj1 = adj1 < 0 ? adj1 + Self.normalizationValue : adj1
        let normalizedAdj2 = adj2 < 0 ? adj2 + Self.normalizationValue : adj2
        
        return [Degrees(normalizedAdj1), Degrees(normalizedAdj2)]
    }
}

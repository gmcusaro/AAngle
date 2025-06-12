//
// ArcSeconds.swift
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

public struct ArcSeconds: Hashable, Codable, Sendable, AAnglable {
    public var rawValue: Double
    public var tolerance: Double
    
    /// Initializes a `ArcSeconds` instance with a raw `Double` value.
    /// 
    /// - Parameter rawValue: The angle in arc second as a `Double`.
    @inlinable
    public init(_ rawValue: Double) {
        self.rawValue = rawValue
        self.tolerance = Self.defaultTolerance
    }
    
    /// The normalization value used for converting and normalizing arc seconds.
    public static let normalizationValue: Double = 1_296_000
        
    /// Converts the `ArcSeconds` value into a `Measurement` object with a `UnitAngle` unit.
    /// This allows the `ArcSeconds` value to be used with `Measurement`-based APIs, such as those that require units of angle.
    ///
    /// - Returns: A `Measurement<UnitAngle>` representing the angle in arc seconds.
    @inlinable
    public func toMeasurement() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: rawValue, unit: .arcSeconds)
    }
}

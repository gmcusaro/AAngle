//
// AAngle.swift
// AAngle
//
// Created by Giovanni Maria Cusaro on 28/02/2026 Copyright 2026
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

/// A property wrapper that stores an angle in a concrete unit type and converts assignments automatically.

///
/// Usage:
/// ```swift
/// @AAngle var degrees = Degrees(45)
/// @AAngle(.radians) var radians: Radians = Degrees(180)
/// ```
@propertyWrapper
public struct AAngle<Wrapped: AAnglable>: Sendable, Codable, Hashable {
    public var wrappedValue: Wrapped

    /// Standard initializer.
    ///
    /// - Parameter wrappedValue: The initial angle value to store.
    public init(wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
    }

    /// Conversion initializer.
    /// Enables assigning any `AAnglable` and storing it as `Wrapped`.
    ///
    /// - Parameter wrappedValue: The input angle value to convert and store as `Wrapped`.
    public init<T: AAnglable>(wrappedValue: T) {
        self.wrappedValue = Wrapped(wrappedValue)
    }

    /// Explicit unit initializer for property-wrapper argument syntax.
    /// Validates the declared unit matches the wrapped storage type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The input angle value to convert and store as `Wrapped`.
    ///   - type: The expected runtime unit for the wrapped storage.
    public init<T: AAnglable>(wrappedValue: T, _ type: AAngleType) {
        precondition(
            ObjectIdentifier(type.metatype) == ObjectIdentifier(Wrapped.self),
            "AAngle type mismatch: requested \(type), but wrapped storage is \(Wrapped.self)."
        )
        self.wrappedValue = Wrapped(wrappedValue)
    }
}

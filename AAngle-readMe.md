# Angle

`AAngle` is a Swift package that provides a flexible and extensible way to work with different types of angles in various units such as [degrees](https://en.wikipedia.org/wiki/Degree_(angle)), [radians](https://en.wikipedia.org/wiki/Radian), [gradians](https://en.wikipedia.org/wiki/Gradian), [revolutions/turn](https://en.wikipedia.org/wiki/Turn_(angle)), [arc minutes, and arc seconds](https://en.wikipedia.org/wiki/Minute_and_second_of_arc).

## Features

Angle Types: supports various angle types including Radians, Degrees, Gradians, Revolutions, Arc Seconds, and Arc Minutes.
Normalization: built-in normalization to keep angles within a specific range.
Arithmetic Operations: supports addition, subtraction, multiplication, and division.
Angle Conversion: Easily convert between different angle types
Measurement Support: convert angle values to Swift's Measurement type for use with units.

## Installation

You can install the package via Swift Package Manager (SPM). Add the following dependency to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/gmcusaro/AAngle.git", from: "1.0.0")
]
```

Or, if using Xcode, go to **File** > **Swift Packages** > **Add Package Dependency**... and provide the repository URL.

## Operators

The primary purpose of Angle types is to represent normalized angles. Don't normalize or bypass normalization defeats this purpose and adds unnecessary complexity. Generally normalization is essential to maintain the core principle of your Angle type: representing angles within a standard range.

`+, -` The regular addition and subtraction operators produce normalized results. This ensures that the resulting angle stays within the intended range (e.g., 0-360 degrees).

`+=, -=` The addition and subtraction assignment operators is normalized to keep the angle within the valid range, especially during repeated operations.

`*` The regular multiplication operator is not normalized. Multiplying an angle by a scalar can produce mathematically valid angles outside the standard range (e.g., 720 degrees).

`*=` The multiplication assignment operator is normalized. Repeated multiplication typically implies a bounded range.

`/` The regular division operator is not normalized. Dividing an angle by a scalar can result in an angle within or outside the normalized range, both normalized and unnormalized results can be mathematically meaningful. Just like with regular multiplication `*`, preserving the resulting magnitude (even if it's outside the normalized range) is important.

`/=` The division assignment operator is normalized. Repeated division could easily produce numbers that grow unbounded and should, like all assignment operators for angles, keep values within the normalized range.

## License

This package is licensed under the MIT License. See LICENSE for more information.


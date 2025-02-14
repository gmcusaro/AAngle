# AAngle

`Angle` is a Swift package that provides a flexible and extensible way to work with different types of angles, including [degrees](https://en.wikipedia.org/wiki/Degree_(angle)), [radians](https://en.wikipedia.org/wiki/Radian), [gradians](https://en.wikipedia.org/wiki/Gradian), [revolutions/turns](https://en.wikipedia.org/wiki/Turn_(angle)), [arc minutes](https://en.wikipedia.org/wiki/Minute_and_second_of_arc), and [arc seconds](https://en.wikipedia.org/wiki/Minute_and_second_of_arc).

## Features

**Angle Types:** Supports various angle types: `Radians`, `Degrees`, `Gradians`, `Revolutions`, `ArcSeconds`, and `ArcMinutes`.
**Normalization:** Built-in normalization to keep angles within a specific range (e.g., 0-360 degrees for `Degrees`).
**Arithmetic Operations:** Supports addition, subtraction, multiplication, and division, with consistent normalization behavior.
**Angle Conversion:** Easily convert between different angle types.
**Measurement Support:** Convert angle values to Swift's `Measurement<UnitAngle>` type for use with the Foundation framework's [units](https://developer.apple.com/documentation/foundation/unitangle).
**Type-Safe Units:** Uses an `AngleType` enum to represent units, ensuring type safety and avoiding string-based errors.
**Extensible Protocol:** Designed with the `Anglable` protocol to make it easy to add custom angle types.
**Complete Operators Support:** Supports all basic arithmetic operators, comparison operators, including `==`, `<`, `<=`, `>`, `>=`, as well as compound assignment operators like `+=`, `-=`, ensuring correct normalization behavior.
**Trigonometry:** Add text

## Installation

You can install the `AAngle` package via [Swift Package Manager](https://www.swift.org/documentation/package-manager/). The supported platforms are:
    ```swift
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .visionOS(.v2),
        .watchOS(.v10),
        .tvOS(.v17)
    ]
    ```

**Using Xcode:**
    1.  Go to **File** > **Add Packages...**
    2.  Enter the repository URL: `https://github.com/gmcusaro/AAngle.git` (Replace with your actual repository URL when you create it).
    3.  Choose "Up to Next Major Version" and specify `1.0.0` (or your initial version) as the starting version.
    4.  Click "Add Package".

**Using [Packages](https://www.swift.org/packages):**
Add the following dependency to your `Package.swift` file:
    ```swift
    dependencies: [
        .package(url: "https://github.com/gmcusaro/AAngle.git", from: "1.0.0")
    ]
    ```

## Usage examples
    ```swift
    import AAngle

    // Create angles
    let degrees = Degrees(90)
    let radians = Radians(Double.pi / 2)
    let revolutions = AngleType.revolutions.initAngle(degress)
    let grads = Gradians() // Init 0.0 grad
    let arcMinutes = ArcMinutes.zero // Init 0.0 arc minutes
    let arcSeconds = AngleType.arcSeconds.initAngle(324000.00000000) // Init 324000.00000000 arc seconds

    // Angle conversions
    let degreesFromRadians = Degrees(radians) // Convert radians to degrees
    let degreesFromRevolutions: Degrees = rev.convertTo(.degrees) as? Degrees // Convert to any Anglable type
    let

    // Arithmetic operators
    let sum = degrees + radians // Adds, converting to the type of the left-hand side (Degrees)
    let difference = radians - degrees // Subtracts, converting to the type of the left-hand side (Radians)
    let product = degrees * 2.0 // Multiplies (not normalized)
    let quotient = radians / 2.0 // Divides (not normalized)
    var mutableDegrees = Degrees(180)
    mutableDegrees += radians
    mutableDegrees -= Int(90)
    mutableDegrees -= Float(45)

    // Comparisons
    print(degrees < Degrees(UInt32(90.0))) // false
    print(degrees == Revolutions) // falses (comparison after conversion)

    // Normalization
    var largeAngle = Degrees(Int(720))
    largeAngle.normalize() // largeAngle is now 0
    let normalizedAngle = largeAngle.normalized() // Creates a new normalized instance.

    // Using Measurement
    let measurement = degrees.toMeasurement()
    print(measurement) // Output: 90.0 deg

    // Accessing to rawValue, description and debugDescription
    print(degrees.rawValue) // 90.0
    print(degrees.description) // "90.0"
    print(degrees.debugDescription) // "Angle(Degrees): rawValue = 90.0, normalized = 90.0"
    ```

## Operators

The `AAngle` types are designed with a core principle: to represent normalized angles whenever appropriate.  Normalization ensures consistency and prevents ambiguity by keeping angles within a predefined range (e.g., 0-360 degrees for `Degrees`, 0-2π radians for `Radians`).  However, some operations, like multiplication and division by scalars, can produce mathematically valid results *outside* this standard range, and preserving these values can be important.  Therefore, the operators in the `Angle` package have specific normalization behaviors:

**`+, -` Addition and Subtraction:**  These operators *always* produce normalized results. The resulting angle is normalized to the standard range of the *left-hand side* operand's type.  This ensures that adding or subtracting angles always results in a value within the expected bounds.  The type of the result is the same as the type of the left-hand side operand.

    ```swift
    let degrees = Degrees(350)
    let radians = Radians(Double.pi / 2) // Equivalent to 90 degrees
    let sum = degrees + radians  // Result: Degrees(80)  (350 + 90 = 440, normalized to 80)
    let difference = radians - degrees // Result: Radians(-4.537856055185257)
    ```

**`+=, -=` Addition and Subtraction Assignment:**  These operators modify the angle *in place* and *always* normalize the result.  They are equivalent to performing the corresponding arithmetic operation and then assigning the normalized value back to the original variable.

    ```swift
    var myAngle = Degrees(350)
    myAngle += 90  // myAngle is now 80 (normalized)
    myAngle -= 100 // myAngle is now 340 (normalized)
    ```

**`*` Multiplication:**  Multiplication by a scalar (Double, Int, etc.) is *not* normalized.  This is because multiplying an angle by a value can legitimately produce an angle outside the standard range (e.g., 2 * 180 degrees = 360 degrees, 3 * 180 degrees = 540 degrees).  Preserving these values is often mathematically necessary.

    ```swift
    let degrees = Degrees(180)
    let doubled = degrees * 2  // Result: Degrees(360) (not normalized)
    let tripled = degrees * 3  // Result: Degrees(540) (not normalized)
    ```

**`*=` Multiplication Assignment:** The multiplication assignment operator *is* normalized. Repeated multiplication, as often done, will result to value to keep within the standard range.

    ```swift
    var degrees = Degrees(180)
    degrees *= 2  // Result: Degrees(0) (normalized)
    ```

**`/` Division:**  Division by a scalar is *not* normalized, for the same reasons as multiplication.  Dividing an angle can produce a smaller or larger angle that may or may not fall within the standard range, and preserving the unnormalized value is often desirable.

    ```swift
    let radians = Radians(Double.pi)
    let halved = radians / 2  // Result: Radians(1.570796326794966) (not normalized, equal to pi/2)
    ```

**`/=` Division Assignment:** The division assignment operator *is* normalized. Repeated division, as often done, will result to value to keep within the standard range.

    ```swift
    var degrees = Degrees(10)
    degrees /= 2  // Result: Degrees(90) (normalized)
    ```

**`==, <, <=, >, >=` Comparison Operators:**  Comparison operators work correctly between `Anglable` instances of *different* types.  Before comparison, the right-hand side operand is converted to the type of the left-hand side operand.  This ensures consistent and accurate comparisons, regardless of the original units. The comparisons use a tolerance value to account for potential floating-point inaccuracies.

    ```swift
    let degrees = Degrees(90)
    let radians = Radians(Double.pi / 2)
    print(degrees == radians) // true (comparison after converting radians to degrees)
    print(degrees < radians)  // false
    ```

### Normalization

The `Anglable` protocol provides methods for normalizing angle values, ensuring they fall within a defined range.  Normalization is crucial for consistency and preventing ambiguity in angle representations. Each conforming type (e.g., `Degrees`, `Radians`) defines its own `normalizationValue` which is a `static` property of the `Anglable` protocol.

**`normalize()`**: Normalizes the angle *in place* to the standard range defined by the conforming type's `normalizationValue`.  For example, for `Degrees`, this would be the range 0 to 360 (exclusive of 360). The `normalize()` methods modify the existing angle.

    ```swift
    var myAngle = Degrees(450)
    myAngle.normalize() // myAngle is now 90
    ```

**`normalized() -> Self`**: Returns a *new* `Anglable` instance containing the normalized value.  The original instance is *not* modified. The `normalized()` methods create a new, normalized angle instance.

    ```swift
    let myAngle = Degrees(450)
    let normalizedAngle = myAngle.normalized() // normalizedAngle is 90, myAngle is still 450
    ```

**`normalize(by value: Double)`***: Normalizes the angle *in place* using a custom normalization value. This is useful if you need a range other than the default. The `normalize()` methods modify the existing angle.

    ```swift
    var myAngle = Radians(3 * Double.pi) // 3π
    myAngle.normalize(by: Double.pi) // myAngle is now π (normalized to the range 0 to π)
    ```

**`normalized(by value: Double) -> Self`**: Returns a *new* `Anglable` instance, normalized using the provided custom normalization value. The original instance is not modified. The `normalized()` methods create a new, normalized angle instance.

    ```swift
    let myAngle = Radians(3 * Double.pi) // 3π
    let normalizedAngle = myAngle.normalized(by: Double.pi) // normalizedAngle is π, myAngle is still 3π
    ```

### Key Design Rationale:

**Normalization by Default (where appropriate):** Addition, subtraction, and assignment operations are normalized by default to maintain the core principle of representing angles within a standard range. This avoids common errors and ensures consistency.

**Preserving Magnitude (when necessary):**  Multiplication and division (without assignment) preserve the magnitude of the result, even if it falls outside the normalized range. This is essential for many mathematical operations where the "unwrapped" angle is significant.

**Type Consistency:**  Binary operations (`+`, `-`) return a value of the *same type* as the left-hand side operand. This makes the behavior predictable and helps prevent accidental type changes.

**Cross-Type Comparisons:** Comparison operators handle different `Anglable` types correctly by performing internal conversions.

**Tolerance:** The comparison operations are performed using a tolerance to prevent errors due to floating-point precision limitations.


## Trigonometry

`AAngle` provides a set of trigonometric functions for **Radians** type.

### Basic Trigonometric Functions

- **Sine**: Returns the sine of the angle.
- **Cosine**: Returns the cosine of the angle.
- **Tangent**: Returns the tangent of the angle.
- **Cotangent**: Returns the cotangent of the angle (1 / tangent). Returns nil if the tangent is zero.
- **Secant**: Returns the secant of the angle (1 / cosine). Returns nil if the cosine is zero.
- **Cosecant**: Returns the cosecant of the angle (1 / sine). Returns nil if the sine is zero.

    ```swift
    import AAngle

    let radians = Radians(Degrees(45))

    // Basic trigonometric functions
    print(radians.sine)      // 0.7071067811865475
    print(radians.cosine)    // 0.7071067811865476
    print(radians.tangent)   // 0.9999999999999999
    print(radians.cotangent) // Optional(1.0000000000000002)
    print(radians.secant)    // Optional(1.414213562373095)
    print(radians.cosecant)  // Optional(1.414213562373095)
    ```

### Triangle Calculations

- **Opposite Leg** `oppositeLeg(hypotenuse:)`: Computes the length of the opposite leg of a right triangle given the hypotenuse.
- **Adjacent Leg** `adjacentLeg(hypotenuse:)`: Computes the length of the adjacent leg of a right triangle given the hypotenuse.
- **Hypotenuse** `hypotenuse(fromOppositeLeg:)`: Computes the hypotenuse of a right triangle given the opposite leg.
- **Hypotenuse** `hypotenuse(fromAdjacentLeg:)`: Computes the hypotenuse of a right triangle given the adjacent leg.
- **Opposite Leg** `oppositeLeg(fromAdjacentLeg:)`: Computes the opposite leg of a right triangle given the adjacent leg.
- **Adjacent Leg** `adjacentLeg(fromOppositeLeg:)`: Computes the adjacent leg of a right triangle given the opposite leg.

    ```swift
    import AAngle

    let radians = Radians(Double.pi / 4) // 45 degrees

    // Triangle calculations
    let hypotenuse = 10.0
    print(radians.oppositeLeg(hypotenuse: hypotenuse)) // 7.0710678118654755
    print(radians.adjacentLeg(hypotenuse: hypotenuse)) // 7.071067811865476
    print(radians.hypotenuse(fromOppositeLeg: 5.0))    // 7.0710678118654755
    print(radians.hypotenuse(fromAdjacentLeg: 5.0))    // 7.071067811865476
    print(radians.oppositeLeg(fromAdjacentLeg: 5.0))   // 5.0
    print(radians.adjacentLeg(fromOppositeLeg: 5.0))   // 5.0
    ```

## License

This package is licensed under the Apache License. See [LICENSE](https://github.com/gmcusaro/AAngle/blob/main/LICENSE) for more information.

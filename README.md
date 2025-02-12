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

You can install the `AAngle` package via [Swift Package Manager](https://www.swift.org/documentation/package-manager/).

**Using Xcode:**

1.  Go to **File** > **Add Packages...**
2.  Enter the repository URL: `https://github.com/gmcusaro/AAngle.git` (Replace with your actual repository URL when you create it).
3.  Choose "Up to Next Major Version" and specify "1.0.0" (or your initial version) as the starting version.
4.  Click "Add Package".

**Using `Package.swift`:**

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
let grads = Gradians() // Init 0.0 grad
let revolutions = Revolutions.zero // Init 0.0 rev
let arcMinutes = ArcMinutes(5400)
let arcSeconds = ArcSeconds(324000)

// Angle conversions
let degreesFromRadians = Degrees(radians) // Convert radians to degrees
let gradsFromDegrees: Gradians = grads.convertTo(.gradians) //Convert to gradians and assign the new angle value to Gradians type.
let revolutionsFromDegrees = degrees.convertTo(.revolutions) //Convert to any Anglable type

// Arithmetic operators
let sum = degrees + radians // Adds, converting to the type of the left-hand side (Degrees)
let difference = radians - degrees // Subtracts, converting to the type of the left-hand side (Radians)
let product = degrees * 2.0 // Multiplies (not normalized)
let quotient = radians / 2.0 // Divides (not normalized)
var mutableDegrees = Degrees(180)
mutableDegrees += radians
mutableDegrees -= 90
print(mutableDegrees)

// Comparisons
print(degrees < Degrees(UInt32(89.0))) // false
print(degrees == radians) // true (comparison after conversion)

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

## Operators and Normalization

The `Angle` types are designed with a core principle: to represent normalized angles whenever appropriate.  Normalization ensures consistency and prevents ambiguity by keeping angles within a predefined range (e.g., 0-360 degrees for `Degrees`, 0-2π radians for `Radians`).  However, some operations, like multiplication and division by scalars, can produce mathematically valid results *outside* this standard range, and preserving these values can be important.  Therefore, the operators in the `Angle` package have specific normalization behaviors:

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

### Key Design Rationale:

**Normalization by Default (where appropriate):** Addition, subtraction, and assignment operations are normalized by default to maintain the core principle of representing angles within a standard range. This avoids common errors and ensures consistency.
**Preserving Magnitude (when necessary):**  Multiplication and division (without assignment) preserve the magnitude of the result, even if it falls outside the normalized range. This is essential for many mathematical operations where the "unwrapped" angle is significant.
**Type Consistency:**  Binary operations (`+`, `-`) return a value of the *same type* as the left-hand side operand. This makes the behavior predictable and helps prevent accidental type changes.
**Cross-Type Comparisons:** Comparison operators handle different `Anglable` types correctly by performing internal conversions.
**Tolerance:** The comparison operations are performed using a tolerance to prevent errors due to floating-point precision limitations.


## Trigonometry

Add text

## License

This package is licensed under the MIT License. See LICENSE for more information.

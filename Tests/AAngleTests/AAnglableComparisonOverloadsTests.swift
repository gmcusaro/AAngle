import Testing
@testable import AAngle

@Suite("AAnglable comparison overloads")
struct AAnglableComparisonOverloadsTests {
    @Test func testEqualityOverloads() {
        let angle = Degrees(180)

        // Existing overloads
        #expect(angle == Degrees(180))
        #expect(angle == Revolutions(0.5))

        // Numeric overloads
        #expect(angle == 180.0)
        #expect(angle == 180)
        #expect(angle == UInt16(180))
        #expect(angle == Float(180))
        #expect(!(angle == 181.0))
        #expect(!(angle == 181))
        #expect(!(angle == UInt16(181)))
        #expect(!(angle == Float(181)))
    }

    @Test func testLessThanOverloads() {
        let angle = Degrees(180)

        // Existing overloads
        #expect(angle < Degrees(181))
        #expect(angle < Revolutions(0.75))

        // Numeric overloads
        #expect(angle < 181.0)
        #expect(angle < 181)
        #expect(angle < UInt16(181))
        #expect(angle < Float(181))
        #expect(!(angle < 180.0))
        #expect(!(angle < 180))
        #expect(!(angle < UInt16(180)))
        #expect(!(angle < Float(180)))
    }

    @Test func testLessThanOrEqualOverloads() {
        let angle = Degrees(180)

        // Existing overloads
        #expect(angle <= Degrees(180))
        #expect(angle <= Revolutions(0.5))

        // Numeric overloads
        #expect(angle <= 180.0)
        #expect(angle <= 180)
        #expect(angle <= UInt16(180))
        #expect(angle <= Float(180))
        #expect(!(angle <= 179.0))
        #expect(!(angle <= 179))
        #expect(!(angle <= UInt16(179)))
        #expect(!(angle <= Float(179)))
    }

    @Test func testGreaterThanOverloads() {
        let angle = Degrees(180)

        // Existing overloads
        #expect(angle > Degrees(179))
        #expect(angle > Revolutions(0.25))

        // Numeric overloads
        #expect(angle > 179.0)
        #expect(angle > 179)
        #expect(angle > UInt16(179))
        #expect(angle > Float(179))
        #expect(!(angle > 180.0))
        #expect(!(angle > 180))
        #expect(!(angle > UInt16(180)))
        #expect(!(angle > Float(180)))
    }

    @Test func testGreaterThanOrEqualOverloads() {
        let angle = Degrees(180)

        // Existing overloads
        #expect(angle >= Degrees(180))
        #expect(angle >= Revolutions(0.5))

        // Numeric overloads
        #expect(angle >= 180.0)
        #expect(angle >= 180)
        #expect(angle >= UInt16(180))
        #expect(angle >= Float(180))
        #expect(!(angle >= 181.0))
        #expect(!(angle >= 181))
        #expect(!(angle >= UInt16(181)))
        #expect(!(angle >= Float(181)))
    }
}

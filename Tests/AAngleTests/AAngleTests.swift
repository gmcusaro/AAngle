import Testing
@testable import AAngle

@Suite("AAngle Property Wrapper Tests")
struct AAnglePropertyWrapperTests {

    @Test func testInferenceStoresSameType() {
        @AAngle var degrees = Degrees(45)
        #expect(degrees.rawValue == 45)
    }

    @Test func testImplicitConversionToAllTypes() {
        @AAngle var degrees: Degrees = Radians(.pi)
        #expect(abs(degrees.rawValue - 180) < 1e-10)

        @AAngle var radians: Radians = Degrees(180)
        #expect(abs(radians.rawValue - .pi) < 1e-10)

        @AAngle var gradians: Gradians = Degrees(180)
        #expect(abs(gradians.rawValue - 200) < 1e-10)

        @AAngle var revolutions: Revolutions = Degrees(180)
        #expect(abs(revolutions.rawValue - 0.5) < 1e-10)

        @AAngle var arcMinutes: ArcMinutes = Degrees(180)
        #expect(abs(arcMinutes.rawValue - 10_800) < 1e-8)

        @AAngle var arcSeconds: ArcSeconds = Degrees(180)
        #expect(abs(arcSeconds.rawValue - 648_000) < 1e-5)
    }

    @Test func testExplicitTypeArgumentToAllTypes() {
        @AAngle(.degrees) var degrees: Degrees = Radians(.pi)
        #expect(abs(degrees.rawValue - 180) < 1e-10)

        @AAngle(.radians) var radians: Radians = Degrees(180)
        #expect(abs(radians.rawValue - .pi) < 1e-10)

        @AAngle(.gradians) var gradians: Gradians = Degrees(180)
        #expect(abs(gradians.rawValue - 200) < 1e-10)

        @AAngle(.revolutions) var revolutions: Revolutions = Degrees(180)
        #expect(abs(revolutions.rawValue - 0.5) < 1e-10)

        @AAngle(.arcMinutes) var arcMinutes: ArcMinutes = Degrees(180)
        #expect(abs(arcMinutes.rawValue - 10_800) < 1e-8)

        @AAngle(.arcSeconds) var arcSeconds: ArcSeconds = Degrees(180)
        #expect(abs(arcSeconds.rawValue - 648_000) < 1e-5)
    }
}

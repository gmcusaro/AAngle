import Testing
import Foundation
@testable import AAngle

@Suite("AAngle Types Tests")
struct AAngleTypesTests {
    @Test func testDescriptionAndMetatypeMapping() {
        let mappings: [(type: AAngleType, description: String, metatype: any AAnglable.Type)] = [
            (.gradians, "gradians", Gradians.self),
            (.degrees, "degrees", Degrees.self),
            (.radians, "radians", Radians.self),
            (.revolutions, "revolutions", Revolutions.self),
            (.arcSeconds, "arc seconds", ArcSeconds.self),
            (.arcMinutes, "arc minutes", ArcMinutes.self),
        ]

        for mapping in mappings {
            #expect(mapping.type.description == mapping.description)
            #expect(ObjectIdentifier(mapping.type.metatype) == ObjectIdentifier(mapping.metatype))
        }
    }

    @Test func testInitAngleNumericOverloadsForAllCases() {
        func assertNumericInitializers<T: AAnglable>(
            _ type: AAngleType,
            as _: T.Type
        ) {
            let fromDouble = type.initAngle(42.5) as! T
            #expect(fromDouble.rawValue == 42.5)

            let floatValue: Float = 12.5
            let fromFloat = type.initAngle(floatValue) as! T
            #expect(fromFloat.rawValue == Double(floatValue))

            let intValue: Int16 = 12
            let fromInt = type.initAngle(intValue) as! T
            #expect(fromInt.rawValue == Double(intValue))
        }

        assertNumericInitializers(.gradians, as: Gradians.self)
        assertNumericInitializers(.degrees, as: Degrees.self)
        assertNumericInitializers(.radians, as: Radians.self)
        assertNumericInitializers(.revolutions, as: Revolutions.self)
        assertNumericInitializers(.arcSeconds, as: ArcSeconds.self)
        assertNumericInitializers(.arcMinutes, as: ArcMinutes.self)
    }

    @Test func testInitAngleFromAAnglableForAllCases() {
        let source = Degrees(180)

        #expect((AAngleType.gradians.initAngle(source) as! Gradians) == Gradians(200))
        #expect((AAngleType.degrees.initAngle(source) as! Degrees) == Degrees(180))
        #expect((AAngleType.radians.initAngle(source) as! Radians) == Radians(.pi))
        #expect((AAngleType.revolutions.initAngle(source) as! Revolutions) == Revolutions(0.5))
        #expect((AAngleType.arcSeconds.initAngle(source) as! ArcSeconds) == ArcSeconds(648000))
        #expect((AAngleType.arcMinutes.initAngle(source) as! ArcMinutes) == ArcMinutes(10800))
    }

    @Test func testConvertToTypeMatchesAAngleTypeInit() {
        let source = Gradians(100)
        let allTypes: [AAngleType] = [
            .gradians, .degrees, .radians, .revolutions, .arcSeconds, .arcMinutes
        ]

        for angleType in allTypes {
            let viaType = angleType.initAngle(source)
            let viaConvert = source.convert(to: angleType)

            #expect(ObjectIdentifier(Swift.type(of: viaType)) == ObjectIdentifier(Swift.type(of: viaConvert)))
            #expect(viaType.rawValue == viaConvert.rawValue)
        }
    }

    @Test func testNonFinitePropagationThroughAAngleType() {
        let nanSource = Degrees(.nan)
        let allTypes: [AAngleType] = [
            .gradians, .degrees, .radians, .revolutions, .arcSeconds, .arcMinutes
        ]

        for angleType in allTypes {
            let converted = angleType.initAngle(nanSource)
            #expect(converted.rawValue.isNaN)
            #expect(ObjectIdentifier(Swift.type(of: converted)) == ObjectIdentifier(angleType.metatype))
        }
    }

    @Test func testAAngleTypeCodableRoundTrip() throws {
        let allTypes: [AAngleType] = [
            .gradians, .degrees, .radians, .revolutions, .arcSeconds, .arcMinutes
        ]

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        for type in allTypes {
            let data = try encoder.encode(type)
            let decoded = try decoder.decode(AAngleType.self, from: data)
            #expect(decoded == type)
        }
    }
    
    @Test func testToleranceScalingDuringConversion() {
        let allTypes: [AAngleType] = [
            .gradians, .degrees, .radians, .revolutions, .arcSeconds, .arcMinutes
        ]

        func assertScaling<S: AAnglable>(_ source: S) {
            var source = source
            source.tolerance = 1e-4

            for angleType in allTypes {
                let target = angleType.converted(from: source)
                let scale = angleType.metatype.normalizationValue / S.normalizationValue
                let expectedRawValue = source.rawValue * scale
                let expectedTolerance = Swift.max(
                    angleType.metatype.defaultTolerance,
                    S.sanitizedTolerance(source.tolerance) * abs(scale)
                )

                #expect(abs(target.rawValue - expectedRawValue) < 1e-12)
                #expect(abs(target.tolerance - expectedTolerance) < 1e-12)
            }
        }

        assertScaling(Degrees(180))
        assertScaling(Radians(.pi))
        assertScaling(Gradians(200))
        assertScaling(Revolutions(0.5))
        assertScaling(ArcSeconds(648_000))
        assertScaling(ArcMinutes(10_800))
    }
}

private extension AAngleType {
    func converted<T: AAnglable>(from source: T) -> any AAnglable {
        source.convert(to: self)
    }
}

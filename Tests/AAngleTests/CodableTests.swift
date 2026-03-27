import Foundation
import Testing
@testable import AAngle

@Suite("Codable Tests")
struct CodableTests {
    @Test func testDegreesDecode() throws {
        let decoder = JSONDecoder()
        let json = """
        {
          "rawValue": 0.25
        }
        """.data(using: .utf8)!

        let decoded = try decoder.decode(Degrees.self, from: json)
        #expect(decoded.rawValue == 0.25)
        #expect(decoded.tolerance == Degrees.defaultTolerance)
    }

    @Test func testDegreesEncode() throws {
        let encoder = JSONEncoder()
        var value = Degrees(0.25)
        value.tolerance = 1e-6

        let encoded = try encoder.encode(value)
        let json = try #require(String(data: encoded, encoding: .utf8))
        #expect(json == #"{"rawValue":0.25}"#)
    }

    @Test func testAAngleTypeDecode() throws {
        let decoder = JSONDecoder()
        let fixtures: [(type: AAngleType, json: String)] = [
            (.gradians, "\"gradians\""),
            (.degrees, "\"degrees\""),
            (.radians, "\"radians\""),
            (.revolutions, "\"revolutions\""),
            (.arcSeconds, "\"arcSeconds\""),
            (.arcMinutes, "\"arcMinutes\"")
        ]

        for fixture in fixtures {
            let decoded = try decoder.decode(AAngleType.self, from: Data(fixture.json.utf8))
            #expect(decoded == fixture.type)
        }
    }

    @Test func testAAngleTypeEncode() throws {
        let encoder = JSONEncoder()
        let fixtures: [(type: AAngleType, json: String)] = [
            (.gradians, "\"gradians\""),
            (.degrees, "\"degrees\""),
            (.radians, "\"radians\""),
            (.revolutions, "\"revolutions\""),
            (.arcSeconds, "\"arcSeconds\""),
            (.arcMinutes, "\"arcMinutes\"")
        ]

        for fixture in fixtures {
            let data = try encoder.encode(fixture.type)
            let json = try #require(String(data: data, encoding: .utf8))
            #expect(json == fixture.json)
        }
    }

    @Test func testAAngleDecode() throws {
        let decoder = JSONDecoder()
        let json = """
        {
          "wrappedValue": {
            "rawValue": 0.25
          }
        }
        """.data(using: .utf8)!

        let degrees = try decoder.decode(AAngle<Degrees>.self, from: json)
        #expect(degrees.wrappedValue.rawValue == 0.25)
        #expect(degrees.wrappedValue.tolerance == Degrees.defaultTolerance)
    }

    @Test func testAAngleEncode() throws {
        let encoder = JSONEncoder()

        var degreesValue = Degrees(0.25)
        degreesValue.tolerance = 1e-6
        let degrees = try encoder.encode(AAngle(wrappedValue: degreesValue))
        #expect(try #require(String(data: degrees, encoding: .utf8)) == #"{"wrappedValue":{"rawValue":0.25}}"#)
    }
}

import Foundation
import Testing
@testable import AAngle

@Suite("Codable Tests")
struct CodableTests {
    @Test func testAngleDecodeForAllTypes() throws {
        try assertAngleDecode(Gradians.self)
        try assertAngleDecode(Degrees.self)
        try assertAngleDecode(Radians.self)
        try assertAngleDecode(Revolutions.self)
        try assertAngleDecode(ArcSeconds.self)
        try assertAngleDecode(ArcMinutes.self)
    }

    @Test func testAngleEncodeForAllTypes() throws {
        try assertAngleEncode(Gradians.self)
        try assertAngleEncode(Degrees.self)
        try assertAngleEncode(Radians.self)
        try assertAngleEncode(Revolutions.self)
        try assertAngleEncode(ArcSeconds.self)
        try assertAngleEncode(ArcMinutes.self)
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

    @Test func testAAngleDecodeForAllTypes() throws {
        try assertAAngleDecode(Gradians.self)
        try assertAAngleDecode(Degrees.self)
        try assertAAngleDecode(Radians.self)
        try assertAAngleDecode(Revolutions.self)
        try assertAAngleDecode(ArcSeconds.self)
        try assertAAngleDecode(ArcMinutes.self)
    }

    @Test func testAAngleEncodeForAllTypes() throws {
        try assertAAngleEncode(Gradians.self)
        try assertAAngleEncode(Degrees.self)
        try assertAAngleEncode(Radians.self)
        try assertAAngleEncode(Revolutions.self)
        try assertAAngleEncode(ArcSeconds.self)
        try assertAAngleEncode(ArcMinutes.self)
    }
}

private extension CodableTests {
    func assertAngleDecode<T: AAnglable>(_: T.Type) throws {
        let decoder = JSONDecoder()
        let json = """
        {
          "rawValue": 0.25
        }
        """.data(using: .utf8)!

        let decoded = try decoder.decode(T.self, from: json)
        #expect(decoded.rawValue == 0.25)
        #expect(decoded.tolerance == T.defaultTolerance)
    }

    func assertAngleEncode<T: AAnglable>(_: T.Type) throws {
        let encoder = JSONEncoder()
        var value = T(0.25)
        value.tolerance = 1e-6

        let encoded = try encoder.encode(value)
        let json = try #require(String(data: encoded, encoding: .utf8))
        #expect(json == #"{"rawValue":0.25}"#)
    }

    func assertAAngleDecode<T: AAnglable>(_: T.Type) throws {
        let decoder = JSONDecoder()
        let json = """
        {
          "wrappedValue": {
            "rawValue": 0.25
          }
        }
        """.data(using: .utf8)!

        let decoded = try decoder.decode(AAngle<T>.self, from: json)
        #expect(decoded.wrappedValue.rawValue == 0.25)
        #expect(decoded.wrappedValue.tolerance == T.defaultTolerance)
    }

    func assertAAngleEncode<T: AAnglable>(_: T.Type) throws {
        let encoder = JSONEncoder()
        var value = T(0.25)
        value.tolerance = 1e-6

        let encoded = try encoder.encode(AAngle<T>(wrappedValue: value))
        let json = try #require(String(data: encoded, encoding: .utf8))
        #expect(json == #"{"wrappedValue":{"rawValue":0.25}}"#)
    }
}

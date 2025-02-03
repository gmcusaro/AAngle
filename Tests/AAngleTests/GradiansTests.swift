import Testing
@testable import AAngle

@Test func example() async throws {
    let deg: Degrees = 45.0  // Direct initialization with Double
    let degInt: Degrees = 90  // Direct initialization with Int
    let degInt8: Degrees = Degrees(Int8(90))   // Works!
    let degInt16: Degrees = Degrees(Int16(180)) // Works!
    let degInt32: Degrees = Degrees(Int32(270))  // Initialization using Int32
    let degUInt64: Degrees = Degrees(UInt64(270))  // Initialization using Int32
    let angle7: Degrees = Degrees(Float(12.5))
 
    
//    AngleType.degrees.instantiateAngle(Int(40))
//    AngleType.degrees.instantiateAngle(40)
//    AngleType.degrees.instantiateAngle(Double(6))
//    AngleType.degrees.instantiateAngle(Float(6))
//    AngleType.degrees.instantiateAngle(Float16(6))
//    AngleType.degrees.instantiateAngle(Float32(6))
//    AngleType.degrees.instantiateAngle(UInt8(6))
//    AngleType.degrees.instantiateAngle(UInt16(6))
//    AngleType.degrees.instantiateAngle(UInt32(6))
//    AngleType.degrees.instantiateAngle(UInt64(6))
//    AngleType.degrees.instantiateAngle(345.68)
}

let arrGrad: [Gradians] = [
    Gradians(0.0),
    Gradians(1.111111111),
    Gradians(100.0),
    Gradians(200.0),
    Gradians(300.0),
    Gradians(400.0),
    Gradians(444.4444444)
]

let arrDeg: [Degrees] = [
    Degrees(0.0),
    Degrees(1.0),
    Degrees(90.0),
    Degrees(180.0),
    Degrees(270.0),
    Degrees(360.0),
    Degrees(400)
]

let arrRad: [Radians] = [
    Radians(0.0),
    Radians(0.0174532925),
    Radians(1.5707963268),
    Radians(3.1415926536),
    Radians(4.7123889804),
    Radians(6.2831853072),
    Radians(6.9813170079)
]

let arrRev: [Revolutions] = [
    Revolutions(0.0),
    Revolutions(0.0027777778),
    Revolutions(0.25),
    Revolutions(0.5),
    Revolutions(0.75),
    Revolutions(1.0),
    Revolutions(1.1111111111)
]

let arrArcSec: [ArcSeconds] = [
    ArcSeconds(0.0),
    ArcSeconds(3600.0),
    ArcSeconds(324000.0),
    ArcSeconds(648000.0),
    ArcSeconds(972000.0),
    ArcSeconds(1296000.0),
    ArcSeconds(1440000.0)
]

let arrArcMin: [ArcMinutes] = [
    ArcMinutes(0.0),
    ArcMinutes(60.0),
    ArcMinutes(5400.0),
    ArcMinutes(10800.0),
    ArcMinutes(16200.0),
    ArcMinutes(21600.0),
    ArcMinutes(24000.0)
]

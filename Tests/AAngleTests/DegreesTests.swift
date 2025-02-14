import Testing
@testable import AAngle

let arrDeg: [Degrees] = [
    Degrees(0.0),
    Degrees(1.0),
    Degrees(90.0),
    Degrees(180.0),
    Degrees(270.0),
    Degrees(360.0),
    Degrees(400)
]

@Test func testDeg() throws {
    for(index, item) in arrGrad.enumerated() {
        let deg = Degrees(item)
        #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRad.enumerated() {
        let deg = Degrees(item)
        #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRev.enumerated() {
        let deg = Degrees(item)
        #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcMin.enumerated() {
        let deg = Degrees(item)
        #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcSec.enumerated() {
        let deg = Degrees(item)
        #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
    }
}

@Test func testNormalizeDegrees() throws {
    #expect(Degrees(450).normalized() == Degrees(90))
    #expect(Degrees(-380).normalized() == Degrees(340))
    #expect(Degrees(1500).normalized() == Degrees(60))
}

@Test func testDegreesOperator() async throws {
    var deg: Degrees = .zero
    deg += Degrees(180.0)
    #expect(deg + Int(20) == Degrees(200.0))
    #expect(deg + UInt8(10) == Degrees(190.0))
    #expect(deg + Float(20) == Degrees(200.0))
    #expect(deg + Revolutions(0.25) == Degrees(270.0))
    #expect(deg - Float(20) == Degrees(160.0))
    #expect(deg - Gradians(100) == Degrees(90.0))
    deg -= 100
    #expect(deg == Degrees(80))
    deg += 100
    #expect(deg == Degrees(180.0))
    #expect(deg * 2 == Degrees(360.0))
    #expect(deg / 3 == Degrees(60.0))
    #expect(deg < Revolutions(0.7))
    #expect(deg > ArcSeconds(324000.0))
    #expect(deg <= Gradians(Gradians(200.0)))
    #expect(deg <= Revolutions(0.5))
    #expect(deg >= Gradians(200.0))
    #expect(deg >= Degrees(180.0))
    #expect(deg == Degrees(180.0))
    #expect(deg == Radians(3.1415926535898))
    #expect(Degrees(510).normalized().rawValue == 150)
    #expect(Degrees(45.0).opposite == Degrees(135.0))
    #expect(Degrees(90.0).opposite == Degrees(90.0))
    #expect(Degrees(180.0).opposite == Degrees(0.0))
    #expect(Degrees(90.0).adjacentAngles() == [Degrees(180.0),Degrees(0.0)])
    #expect(Degrees(180.0).adjacentAngles() == [Degrees(270.0),Degrees(90.0)])
    #expect(Degrees(360.0).adjacentAngles() == [Degrees(90.0),Degrees(270.0)])
    #expect(Degrees(270.0).adjacentAngles() == [Degrees(0.0),Degrees(180.0)])
}

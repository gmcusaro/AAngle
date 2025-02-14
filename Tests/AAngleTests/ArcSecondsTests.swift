import Testing
@testable import AAngle

let arrArcSec: [ArcSeconds] = [
    ArcSeconds(0.0),
    ArcSeconds(3600.000000000),
    ArcSeconds(324000.00000000),
    ArcSeconds(648000.00000000),
    ArcSeconds(972000.00000000),
    ArcSeconds(1296000.00000000),
    ArcSeconds(1439999.99999999)
]

//28799999.999998
//15839999,999998
//14543999,999998
//1583999,999998

@Test func testArcSec() async throws {
    for(index, item) in arrDeg.enumerated() {
        let arcSec = ArcSeconds(item)
        #expect((arcSec.rawValue - arrArcSec[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrGrad.enumerated() {
        let arcSec = ArcSeconds(item)
        #expect((arcSec.rawValue - arrArcSec[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRad.enumerated() {
        let arcSec = ArcSeconds(item)
        print(index, arcSec)
        #expect((arcSec.rawValue - arrArcSec[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRev.enumerated() {
        let arcSec = ArcSeconds(item)
        #expect((arcSec.rawValue - arrArcSec[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcMin.enumerated() {
        let arcSec = ArcSeconds(item)
        #expect((arcSec.rawValue - arrArcSec[index].rawValue).magnitude < 0.000001)
    }
}

@Test func testNormalizeArcSeconds() throws {
    #expect(ArcSeconds(2592000.00000000).normalized() == ArcSeconds(0.0))
    #expect(ArcMinutes(2735999.00000000).normalized() == ArcMinutes(14399.0000000))
    #expect(ArcMinutes(28799999.999998).normalized() == ArcMinutes(7199.999997999519))
}

@Test func testArcSecondsOperator() throws {
    var arcSec: ArcSeconds = .zero
    arcSec += 324000.00000000
    #expect(arcSec + Float(100) == ArcSeconds(324100.00000000))
    #expect(arcSec + Int(1000) == ArcSeconds(325000.00000000))
    #expect(arcSec + Degrees(90) == ArcSeconds(648000.0000000))
    #expect(arcSec + Gradians(100) == ArcSeconds(648000.0000000))
    #expect(arcSec - Float(100) == ArcSeconds(323900.0000000))
    #expect(arcSec - Int(20000) == ArcSeconds(304000.0000000))
    #expect(arcSec - Revolutions(0.5) == ArcSeconds(972000.00000000))
    arcSec -= 300000.000000000
    #expect(arcSec == ArcSeconds(24000.0000000))
    arcSec += 300000.000000000
    #expect(arcSec == Degrees(90))
    #expect(arcSec == Revolutions(0.25))
    #expect(arcSec == Radians(1.5707963267948966))
    #expect(arcSec * 2 == ArcSeconds(648000.00000000))
    #expect(arcSec / 3 == ArcSeconds(108000.00000000))
    #expect(arcSec < ArcSeconds(324000.10000000))
    #expect(arcSec > ArcSeconds(323999.0000000))
    #expect(arcSec <= Revolutions(0.25))
    #expect(arcSec >= Degrees(89.9999999999))
}

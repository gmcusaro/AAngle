import Testing
@testable import AAngle

let arrRev: [Revolutions] = [
    Revolutions(0.0),
    Revolutions(0.002777777778),
    Revolutions(0.25),
    Revolutions(0.5),
    Revolutions(0.75),
    Revolutions(1.0),
    Revolutions(1.111111111111)
]

@Test func testRev() throws {
    for(index, item) in arrDeg.enumerated() {
        let rev = Revolutions(item)
        #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrGrad.enumerated() {
        let rev = Revolutions(item)
        #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRad.enumerated() {
        let rev = Revolutions(item)
        #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcMin.enumerated() {
        let rev = Revolutions(item)
        #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcSec.enumerated() {
        let rev = Revolutions(item)
        #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
    }
}

@Test func testNormalizeRevolutions() throws {
    #expect(Revolutions(1.5).normalized().rawValue == 0.50)
}

@Test func testRevolutionsOperator() throws {
    var rev: Revolutions = .zero
    rev += 0.25
    rev += Revolutions(0.25)
    #expect(rev + 0.25 == Revolutions(0.75))
    #expect(rev + Int(3) == Revolutions(0.5))
    #expect(rev + Float(1) == Revolutions(0.5))
    #expect(rev + UInt64(2) == Revolutions(0.5))
    #expect(rev + Degrees(90) == Revolutions(0.75))
    #expect(rev - 0.25 == Revolutions(0.25))
    #expect(rev - Int(1) == Revolutions(0.5))
    #expect(rev - Float(2.5) == Revolutions(0.0))
    #expect(rev - UInt64(2) == Revolutions(0.5))
    #expect(rev - Degrees(90) == Revolutions(0.25))
    rev -= 0.75
    #expect(rev == Revolutions(0.75))
    #expect(rev == Radians(4.7123889803847))
    #expect(rev == ArcMinutes(16200.0))
    #expect(rev * 2 == Revolutions(1.5))
    #expect(rev / 3 == Revolutions(0.25))
    #expect(rev / 3 == Revolutions(Degrees(90)))
    #expect(rev < Revolutions(0.751))
    #expect(rev > Radians(4.711))
    #expect(rev <= Revolutions(0.7500001))
    #expect(rev >= Degrees(270.0))
    #expect(rev >= Revolutions(0.2499999999999))
}

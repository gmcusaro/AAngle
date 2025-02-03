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

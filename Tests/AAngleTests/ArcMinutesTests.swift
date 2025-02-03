import Testing
@testable import AAngle

let arrArcMin: [ArcMinutes] = [
    ArcMinutes(0.0),
    ArcMinutes(60.0),
    ArcMinutes(5400.0),
    ArcMinutes(10800.0),
    ArcMinutes(16200.0),
    ArcMinutes(21600.0),
    ArcMinutes(24000.0)
]

@Test func testArcMin() async throws {
    for(index, item) in arrDeg.enumerated() {
        let arcMin = ArcMinutes(item)
        #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrGrad.enumerated() {
        let arcMin = ArcMinutes(item)
        #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRad.enumerated() {
        let arcMin = ArcMinutes(item)
        #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRev.enumerated() {
        let arcMin = ArcMinutes(item)
        #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcSec.enumerated() {
        let arcMin = ArcMinutes(item)
        #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
    }
}

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

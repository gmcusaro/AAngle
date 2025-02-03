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

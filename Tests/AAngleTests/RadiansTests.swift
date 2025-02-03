import Testing
@testable import AAngle

let arrRad: [Radians] = [
    Radians(0.0),
    Radians(0.0174532925199),
    Radians(1.5707963267949),
    Radians(3.1415926535898),
    Radians(4.7123889803847),
    Radians(6.2831853071796),
    Radians(6.9813170079773)
]

@Test func testRad() throws {
    for(index, item) in arrDeg.enumerated() {
        let rad = Radians(item)
        #expect((rad.rawValue - arrRad[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrGrad.enumerated() {
        let rad = Radians(item)
        #expect((rad.rawValue - arrRad[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRev.enumerated() {
        let rad = Radians(item)
        #expect((rad.rawValue - arrRad[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcMin.enumerated() {
        let rad = Radians(item)
        #expect((rad.rawValue - arrRad[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcSec.enumerated() {
        let rad = Radians(item)
        #expect((rad.rawValue - arrRad[index].rawValue).magnitude < 0.000001)
    }
}

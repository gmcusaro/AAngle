import Testing
@testable import AAngle

let arrGrad: [Gradians] = [
    Gradians(0.0),
    Gradians(1.1111111111111111111),
    Gradians(100.0),
    Gradians(200.0),
    Gradians(300.0),
    Gradians(400.0),
    Gradians(444.44444444444444444)
]

@Test func testGrad() throws {
    for(index, item) in arrDeg.enumerated() {
        let grad = Gradians(item)
        #expect((grad.rawValue - arrGrad[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRad.enumerated() {
        let grad = Gradians(item)
        #expect((grad.rawValue - arrGrad[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrRev.enumerated() {
        let grad = Gradians(item)
        #expect((grad.rawValue - arrGrad[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcMin.enumerated() {
        let grad = Gradians(item)
        #expect((grad.rawValue - arrGrad[index].rawValue).magnitude < 0.000001)
    }
    for(index, item) in arrArcSec.enumerated() {
        let grad = Gradians(item)
        #expect((grad.rawValue - arrGrad[index].rawValue).magnitude < 0.000001)
    }
}

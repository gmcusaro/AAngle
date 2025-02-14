import Testing
import Foundation
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

@Test func testNormalizeGradians() throws {
    #expect(Gradians(700).normalized() == Gradians(300))
    #expect(Gradians(1200).normalized() == Gradians(0.0))
    #expect(Gradians(1300).normalized() == Gradians(100.0))
}

@Test func testGradiansOperator() async throws {
    var grad: Gradians = Gradians.zero
    grad += UInt8(100)
    #expect(grad + 10 == Gradians(110))
    #expect(grad + Int(20) == Gradians(120))
    #expect(grad + UInt32(30) == Gradians(130))
    #expect(grad + Degrees(90) == Gradians(200))
    #expect(grad + CGFloat(40) == Gradians(140))
    #expect(grad - Int(20) == Gradians(80))
    #expect(grad - UInt32(30) == Gradians(70))
    #expect(grad - Revolutions(0.25) == Gradians(0))
    grad -= 50
    #expect(grad == Gradians(50))
    #expect(grad == Degrees(45))
    #expect(grad == Revolutions(Degrees(45)))
    grad += 50
    #expect(grad == Gradians(100))
    #expect(grad * 2 == Gradians(200))
    #expect(grad / 3 == Gradians(33.333333333333))
    #expect(grad < Gradians(100.0000000001))
    #expect(grad > Degrees(89.9999999999))
    #expect(grad >= Degrees(Degrees(90)))
    #expect(grad >= Degrees(90))
    #expect(grad <= Degrees(90))
    #expect(grad == Revolutions(0.25))
    #expect(grad == ArcMinutes(5400.0))
}

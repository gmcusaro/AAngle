import Testing
@testable import AAngle
import Foundation

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

@Test func testNormalizeRadians() throws {
    #expect(Radians(3 * .pi).normalized() == Radians(.pi))
    #expect(Radians(4 * .pi).normalized() == Radians(0.0))
    #expect(Radians(-.pi).normalized() == Radians(.pi))
    #expect(Radians(1.5 * .pi).normalized() == Radians(1.5 * .pi))
}

@Test func testRadiansOperator() throws {
    var rad: Radians = .zero
    rad += Radians(1.5707963267949)
    #expect(rad + Degrees(90.0) == Radians(3.1415926535898))
    #expect(rad + 1.5707963267949 == Radians(Degrees(180)))
    #expect(rad + 1 == Radians(2.5707963267949))
    #expect(rad - 0.5707963267949 == Radians(1.0))
    rad += Radians(4.7123889803847)
    #expect(rad == Radians(0.0000000000000))
    rad -= 4.7123889803847
    #expect(rad == 1.5707963267949)
    #expect(rad * 2 == Radians(3.1415926535898))
    #expect(rad / 2 == Radians(0.7853981633975))
    #expect(rad < Degrees(90.1))
    #expect(rad > Gradians(99.9))
    #expect(rad <= Degrees(90.0000000001))
    #expect(rad >= Revolutions(0.25))
    #expect(rad >= Revolutions(0.2499999999999))
    #expect(rad == Radians(1.5707963267949))
    #expect(rad == ArcMinutes(5400.0))
    #expect(Radians(18.8495559215).normalized().rawValue == 6.283185307140826)
    #expect(rad.sine == 1.0)
    #expect(rad.cosine == -3.4914813388431334e-15)
    #expect(rad.tangent == -286411383293069.4375)
    #expect(rad.secant == nil)
    #expect(rad.cosecant == 1.0)
    #expect(rad.cotangent == -3.4914813388431337e-15)
}

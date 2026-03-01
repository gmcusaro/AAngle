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

@Suite("Gradians tests")
struct GradiansTests {
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
    
    @Test func testGradiansNaN() {
        let nanGradians = Gradians(.nan)
        let infGradians = Gradians(.infinity)
        let negInfGradians = Gradians(-.infinity)
        let value = Gradians(5)
        
        #expect(nanGradians.normalized().rawValue.isNaN)
        #expect((nanGradians + value).rawValue.isNaN)
        #expect((value + nanGradians).rawValue.isNaN)
        #expect((nanGradians - value).rawValue.isNaN)
        #expect((value - nanGradians).rawValue.isNaN)
        #expect((nanGradians * value).rawValue.isNaN)
        #expect((value * nanGradians).rawValue.isNaN)
        #expect((nanGradians / value).rawValue.isNaN)
        #expect((value / nanGradians).rawValue.isNaN)
        #expect((-nanGradians).rawValue.isNaN)
        
        //In-Place
        var mutableNan = Gradians(.nan)
        mutableNan += value
        #expect(mutableNan.rawValue.isNaN)
        
        mutableNan = Gradians(.nan) //Reset
        mutableNan -= value
        #expect(mutableNan.rawValue.isNaN)
        
        #expect(infGradians.normalized().rawValue.isInfinite)
        #expect((infGradians / value).rawValue.isNaN)
        #expect((-infGradians).rawValue.isNaN)
        #expect((infGradians + value).rawValue.isNaN)
        
        #expect(infGradians.description == "+Inf")
        #expect(negInfGradians.description == "-Inf")
        #expect(nanGradians.description == "NaN")
    }

    @Test func testGradiansApproximateAndEquivalent() {
        #expect(Gradians(100).isApproximatelyEqual(to: Degrees(90)))
        #expect(!Gradians(100).isApproximatelyEqual(to: Gradians(100.01), tolerance: 0.001))
        #expect(Gradians(10).isEquivalent(to: Gradians(410)))
    }

    @Test func testGradiansIsEquivalent() {
        #expect(Gradians(50).isEquivalent(to: Gradians(450)))
        #expect(Gradians(100).isEquivalent(to: Degrees(90)))
        #expect(!Gradians(10).isEquivalent(to: Gradians(20), tolerance: 0.001))
    }
}
